# ResizeRotateView
MyMaskView (Custom view) with Resize &amp; Rotate control at corner as well as with gesture.


## MyMaskView :

You need to add this class into your view as subview. Otherthings will be handle by implicitly.

Swift Code for add into subview

````
func addMask(){
		let mask1 = MyMaskView(frame: CGRect(x: 50, y: 50, width: 150, height: 150))
		self.imgMain.addSubview(mask1)
		mask1.hideResizeControls()
	}
````
