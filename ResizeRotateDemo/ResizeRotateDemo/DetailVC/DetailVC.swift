
//
//  DetailVC.swift
//  ResizeRotateDemo
//
//  Created by Girish Chauhan on 02/11/18.
//  Copyright © 2018 Seashore_MacMini. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {

	@IBOutlet weak var imgMain: UIImageView!
	var imagePhoto: UIImage!
	
	override func viewDidLoad() {
        super.viewDidLoad()

		
    }
	
	override func viewDidAppear(_ animated: Bool) {
		imgMain.image = imagePhoto
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func handleSwipeDown(_ sender: UISwipeGestureRecognizer) {
		if sender.state == .ended {
			self.dismiss(animated: true, completion: nil)
		}
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
