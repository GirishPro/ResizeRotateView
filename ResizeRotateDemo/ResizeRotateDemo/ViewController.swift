//
//  ViewController.swift
//  ResizeRotateDemo
//
//  Created by Girish Chauhan on 02/10/18.
//  Copyright © 2018 Seashore_MacMini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var imgMain: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Tap Gesture : Show Controls
		let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
		self.view.addGestureRecognizer(tap)
	}
	override func viewDidAppear(_ animated: Bool) {
		self.addMask()
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	//MARK:- Tap
	@objc func handleTap(recognizer: UITapGestureRecognizer){
		print("Main View tapped")
		self.hideAllMask()
	}
	func hideAllMask(){
		for item in self.imgMain.subviews {
			if let mask = item as? MyMaskView {
				mask.hideResizeControls()
			}
		}
	}
	
	func addMask(){
		let mask1 = MyMaskView(frame: CGRect(x: 50, y: 50, width: 150, height: 150))
		self.imgMain.addSubview(mask1)
		mask1.hideResizeControls()
	}

	func renderImageView(){

	}
	
	@IBAction func showDetail(){
		hideAllMask()
		
		let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
		
		// Render
		let renderer = UIGraphicsImageRenderer(bounds: CGRect(x: 0, y: 0, width: self.imgMain.frame.width, height: self.imgMain.frame.height))
		let image = renderer.image { ctx in
			self.imgMain.drawHierarchy(in: self.imgMain.bounds, afterScreenUpdates: true)
		}
		detailVC.imagePhoto = image
		
		self.present(detailVC, animated: true, completion: nil)
	}
}

