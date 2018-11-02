//
//  MyMaskView.swift
//  ResizeRotateDemo
//
//  Created by Girish Chauhan on 02/10/18.
//  Copyright © 2018 Seashore_MacMini. All rights reserved.
//

import UIKit

class MyMaskView: UIView {

	var imgPhoto: UIImageView!
	var imgClose: UIImageView!
	var imgRotate: UIImageView!
	var viewBorder: UIView!
	let widthControl = CGFloat(40.0)
	let heightControl = CGFloat(40.0)
	
	private
	var centerPoint: CGPoint = CGPoint(x: 0.0, y: 0.0)
	var firstDistance: CGFloat = 0.0
	var lastScale: CGFloat = 0.0
	var deltaAngle: CGFloat = 0.0
	var firstTouchPoint: CGPoint = CGPoint(x: 0.0, y: 0.0)
	var startCenterPoint: CGPoint = CGPoint(x: 0.0, y: 0.0)
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		viewBorder = UIView(frame: CGRect(x: widthControl/2.0, y: widthControl/2.0, width: frame.width - widthControl, height: frame.height - heightControl))
		viewBorder.backgroundColor = UIColor.white.withAlphaComponent(0.5)
		self.addSubview(viewBorder)
		
		imgPhoto = UIImageView(frame: CGRect(x: widthControl, y: heightControl, width: frame.width - widthControl*2.0, height: frame.height - heightControl*2.0))
		imgPhoto.image = UIImage(named: "lov12")
		self.addSubview(imgPhoto)
		
		imgClose = UIImageView(frame: CGRect(x: 0, y: 0, width: widthControl, height: heightControl))
		imgClose.image = UIImage(named: "close")		
		self.addSubview(imgClose)
		
		imgRotate = UIImageView(frame: CGRect(x: frame.width - widthControl, y: frame.height - heightControl, width: widthControl, height: heightControl))
		//imgRotate.image = UIImage(named: "close")
		imgRotate.backgroundColor = UIColor.white
		imgRotate.layer.cornerRadius = widthControl/2.0
		imgRotate.layer.masksToBounds = true
		self.addSubview(imgRotate)
		
		// Tap Gesture : Close
		let tapClose = UITapGestureRecognizer(target: self, action: #selector(handleTapClose(recognizer:)))
		imgClose.isUserInteractionEnabled = true
		imgClose.addGestureRecognizer(tapClose)
		
		// Tap Gesture : Show Controls
		let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
		self.addGestureRecognizer(tap)
		
		// Pinch Gesture : Zoom
		let pinchZoom = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchZoom(recognizer:)))
		pinchZoom.delegate = self
		self.addGestureRecognizer(pinchZoom)
		
		// Rotate Gesture : Rotate
		let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate(recognizer:)))
		rotateGesture.delegate = self
		self.addGestureRecognizer(rotateGesture)
		
		// Pan Gesture : Move
		let panMove = UIPanGestureRecognizer(target: self, action: #selector(handlePanMove(recognizer:)))
		viewBorder.isUserInteractionEnabled = true
		viewBorder.addGestureRecognizer(panMove)
		
		// Pan Gesture : Rotate & Resize
		let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanResizeRotate(recognizer:)))
		imgRotate.isUserInteractionEnabled = true
		imgRotate.addGestureRecognizer(panGesture)
		
		// Current Angle
		deltaAngle = atan2(self.frame.origin.y + self.frame.height - self.center.y,
							self.frame.origin.x + self.frame.width - self.center.x)
		lastScale = 1
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	//MARK:- Hide/Show Controls
	func hideResizeControls(){
		self.viewBorder.isHidden = true
		self.imgClose.isHidden = true
		self.imgRotate.isHidden = true
	}
	func showResizeControls(){
		self.viewBorder.isHidden = false
		self.imgClose.isHidden = false
		self.imgRotate.isHidden = false
	}
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.showResizeControls()
	}
	//MARK:- Tap Close
	@objc func handleTapClose(recognizer: UITapGestureRecognizer){
		self.removeFromSuperview()
	}
	//MARK:- Tap
	@objc func handleTap(recognizer: UITapGestureRecognizer){
		self.showResizeControls()
	}
	
	//MARK:- Pinch : Zoom / Rotate
	@objc func handlePinchZoom(recognizer: UIPinchGestureRecognizer){
		if recognizer.numberOfTouches != 2 {
			return
		}
		if recognizer.state == .began {
			centerPoint = self.center
			
		}
		else if recognizer.state == .changed {
			var tranScale = recognizer.view!.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
			
			var rect = self.bounds
			rect = rect.applying(tranScale)
			
			if recognizer.scale > 1.0 && rect.size.height > (self.superview!.frame.size.height * 4.0) {
				tranScale = recognizer.view!.transform
			}
			
			recognizer.scale = 1.0
			self.transform = tranScale
			
			// Invert Transform
			let scaleInvert = sqrt(self.transform.a * self.transform.a + self.transform.b * self.transform.b )
			let transScaleOnly = CGAffineTransform.init(scaleX: scaleInvert, y: scaleInvert)
			let transInvert = transScaleOnly.inverted()
			imgRotate.transform = transInvert
			imgClose.transform = transInvert
		}
		else if recognizer.state == .ended {
			lastScale = lastScale + (recognizer.scale - 1)
		}
	}
	
	//MARK:- Rotate: Gesture
	@objc func handleRotate(recognizer: UIRotationGestureRecognizer){
		recognizer.view!.transform = recognizer.view!.transform.rotated(by: recognizer.rotation)
		recognizer.rotation = 0
	}
	
	//MARK:- Pan : Move
	@objc func handlePanMove(recognizer: UIPanGestureRecognizer){
		if recognizer.state == .began {
			firstTouchPoint = self.center //recognizer.location(in: self.superview)
		}
		else if recognizer.state == .changed {
//			let translatePoint = recognizer.location(in: self.superview)
			let translatePoint = recognizer.translation(in: self.superview)
			let diffX = firstTouchPoint.x + translatePoint.x
			let diffY = firstTouchPoint.y + translatePoint.y
			self.center = CGPoint(x: diffX, y: diffY)
//			self.center = CGPoint(x: self.center.x - diffX, y: self.center.y - diffY)
			//firstTouchPoint = translatePoint
		}
	}
	
	//MARK:- Pan : Resize  & Rotate
	@objc func handlePanResizeRotate(recognizer: UIPanGestureRecognizer){
		if recognizer.state == .began {
			// Resize
			centerPoint = self.center //recognizer.view!.superview!.center
			
			let tran = self.transform
			lastScale = sqrt(tran.a * tran.a + tran.b * tran.b)
			
			let endPoint = recognizer.location(in: self.superview)
			let xPos = endPoint.x, yPos = endPoint.y
			let xDist = centerPoint.x - xPos
			let yDis = centerPoint.y - yPos
			
			firstDistance =  sqrt( (xDist * xDist) + (yDis * yDis) )		
		}
		else if recognizer.state == .changed {
			// New Distance Calculate
			let endPoint = recognizer.location(in: self.superview)
			let xPos = endPoint.x, yPos = endPoint.y
			let xDist = centerPoint.x - xPos
			let yDis = centerPoint.y - yPos
			let distance = sqrt( (xDist * xDist) + (yDis * yDis) )
			
			// Scale Transform
			var scale = (lastScale * distance) / firstDistance
			var tranScale = CGAffineTransform.init(scaleX: scale, y: scale)
			var rect = self.bounds
			rect = rect.applying(tranScale)
			
			// Check for Min Size Limit
			let limit = CGFloat(60.0)
			if rect.size.width < limit || rect.size.height < limit {
				scale = sqrt(self.transform.a * self.transform.a + self.transform.b * self.transform.b)
				tranScale = CGAffineTransform.init(scaleX: scale, y: scale)
			}
			
			// Rotate Transform
			let angle = atan2(endPoint.y - self.center.y, endPoint.x - self.center.x)
			let angleDiff = deltaAngle - angle
			let tranRotate = tranScale.rotated(by: -angleDiff)
			
			// Apply New Transform
			self.transform = tranRotate
			
			// Revert Transform change to controll
			imgClose.transform = tranScale.inverted()
			imgRotate.transform = tranScale.inverted()
			
		}
		else if recognizer.state == .ended {
			self.setNeedsDisplay()
			let scale = sqrt( self.transform.a * self.transform.a + self.transform.b * self.transform.b)
			let tran = CGAffineTransform.init(scaleX: scale, y: scale)
			imgRotate.transform = tran.inverted()
			lastScale = scale
		}
	}
	
}

extension MyMaskView: UIGestureRecognizerDelegate {
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
}
