//
//  MailboxViewController.swift
//  Mailbox
//
//  Created by Min Hu on 5/20/15.
//  Copyright (c) 2015 Min Hu. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController, UIScrollViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate {
	
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var helpLableView: UIImageView!
	@IBOutlet weak var searchView: UIImageView!
	@IBOutlet weak var messageView: UIImageView!
	@IBOutlet weak var feedView: UIImageView!
	@IBOutlet weak var messageContainerView: UIView!
	@IBOutlet weak var laterIconView: UIImageView!
	@IBOutlet weak var backgroundView: UIView!
	@IBOutlet weak var listIconView: UIImageView!
	@IBOutlet weak var archiveIconView: UIImageView!
	@IBOutlet weak var listOptionOverlayView: UIImageView!
	@IBOutlet weak var deleteIconView: UIImageView!
	@IBOutlet weak var rescheduleOptionOverlayView: UIImageView!
	@IBOutlet weak var overlayButton: UIButton!
	@IBOutlet weak var mailContainerView: UIView!
	@IBOutlet weak var menuView: UIImageView!
	@IBOutlet weak var composeView: UIImageView!
	@IBOutlet weak var grayBackgroundView: UIView!
	@IBOutlet weak var segementedControl: UISegmentedControl!
	@IBOutlet weak var laterScreenView: UIImageView!
	@IBOutlet weak var archiveScreenView: UIImageView!
	@IBOutlet weak var yellowNavView: UIImageView!
	@IBOutlet weak var greenNavView: UIImageView!
	@IBOutlet weak var toTextField: UITextField!
	@IBOutlet weak var hamburgerMenuButton: UIButton!
	@IBOutlet weak var cancelButton: UIButton!
	
	
	let blueColor = UIColor(red: 68/255, green: 170/255, blue: 210/255, alpha: 1)
	let yellowColor = UIColor(red: 254/255, green: 202/255, blue: 22/255, alpha: 1)
	let brownColor = UIColor(red: 206/255, green: 150/255, blue: 98/255, alpha: 1)
	let greenColor = UIColor(red: 85/255, green: 213/255, blue: 80/255, alpha: 1)
	let redColor = UIColor(red: 231/255, green: 61/255, blue: 14/255, alpha: 1)
	let grayColor = UIColor(red: 178/255, green: 178/255, blue: 178/255, alpha: 1)

	var actionSheet = UIActionSheet(title: nil, delegate: nil, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Delete Draft", otherButtonTitles: "Keep Draft")
	var mailContainerEdgeGesture: UIScreenEdgePanGestureRecognizer!
	var mailContainerPanGesture: UIPanGestureRecognizer!

	
	//define delay function
	func delay(delay:Double, closure:()->()) {
		dispatch_after(
			dispatch_time(
				DISPATCH_TIME_NOW,
				Int64(delay * Double(NSEC_PER_SEC))
			),
			dispatch_get_main_queue(), closure)
	}
	
	// Set all icon opacity to zero
	func setIconAlpahToZero(){
		laterIconView.alpha = 0
		listIconView.alpha = 0
		archiveIconView.alpha = 0
		deleteIconView.alpha = 0
	}
	
	func setScreenPosition(){
		laterScreenView.center.x = -160
		scrollView.center.x = 160
		archiveScreenView.center.x = 480
	}

	
//	backgroundView.backgroundColor = grayColor
	
	var messageOrigin: CGPoint!
	var messageInitial: CGPoint!
	var feedCenterOrigin: CGPoint!
	var messageContainerOrign: CGPoint!
	var mailContainerOrigin: CGPoint!
	var currentSegementedIndex: Int!
	
	func convertValue(value: Float, r1Min: Float, r1Max: Float, r2Min: Float, r2Max: Float) -> Float{
		var ratio = (r2Max - r2Min)/(r1Max - r1Min)
		return value * ratio + r2Min - r1Min * ratio
	}

	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		//set scrollView delegate
		scrollView.delegate = self
		actionSheet.delegate = self
		
		//user a varable to store feed center value
		feedCenterOrigin = feedView.center
		messageContainerOrign = messageContainerView.center
		messageInitial = messageView.center
		
		//set all icons to zero opacity
		listOptionOverlayView.alpha = 0
		rescheduleOptionOverlayView.alpha = 0
		overlayButton.enabled = false
		listIconView.alpha = 0
		archiveIconView.alpha = 0
		laterIconView.alpha = 0
		deleteIconView.alpha = 0
		grayBackgroundView.alpha = 0
		laterScreenView.alpha = 0
		yellowNavView.alpha = 0
		greenNavView.alpha = 0
		
		//set current segemented control index
		currentSegementedIndex = 1
		
//		composeButton.becomeFirstResponder()
		
		var edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
		edgeGesture.edges = UIRectEdge.Left
		mailContainerView.addGestureRecognizer(edgeGesture)
		mailContainerEdgeGesture = edgeGesture
//		
		var PanGesture = UIPanGestureRecognizer(target: self, action: "onPanMailContainerView:")
		mailContainerView.addGestureRecognizer(PanGesture)
		mailContainerPanGesture = PanGesture
		mailContainerPanGesture.enabled = false
		
		scrollView.contentSize = CGSize(width:320, height: (helpLableView.image!.size.height + searchView.image!.size.height + messageView.image!.size.height + feedView.image!.size.height))
		


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func didPanMessage(sender: UIPanGestureRecognizer) {
		var location = sender.locationInView(messageContainerView)
		var translation = sender.translationInView(messageContainerView)
		var velocity = sender.velocityInView(messageContainerView)
		
		
		if sender.state == UIGestureRecognizerState.Began {
			messageOrigin = messageView.center
		}
		
		else if sender.state == UIGestureRecognizerState.Changed {
			// User a varaiable to store message center position as dragging
			messageView.center = CGPoint(x: translation.x + messageOrigin.x, y: self.messageView.center.y)
			var messageCenter = Float(messageView.center.x)

			
			//Drag left for less than 60px
			if (messageCenter >=  100) && (messageCenter < 160) {
				setIconAlpahToZero()
//				listIconView.alpha = 0
				self.backgroundView.backgroundColor = grayColor
				
				//Convert message center position to opacity value
				var latericonOpacity = CGFloat(convertValue(messageCenter, r1Min: 145.0, r1Max: 100, r2Min: 0, r2Max: 1.0))

				
				//animate opacity change
//				UIView.animateWithDuration(0.3, animations: {() -> Void in
//					self.backgroundView.alpha = backgroundOpacity
//				})
				self.laterIconView.alpha = latericonOpacity

			}
			
			//Drag left for between 60px to full length
			else if (messageCenter < 100) && (messageCenter > -100){
				setIconAlpahToZero()
				laterIconView.alpha = 1
				// Change background to yellow
				self.backgroundView.backgroundColor = yellowColor
				//Move later icon with the drag
				var laterIconPosition = CGFloat(self.convertValue(messageCenter, r1Min: 100, r1Max: -100, r2Min: 287.5, r2Max: 92.5))
				
				self.laterIconView.center.x = laterIconPosition
//				println(laterIconPosition)

			}
			
			//Drag left for pass 260px
			else if (messageCenter < -100){
				// Change background to brown
				self.backgroundView.backgroundColor = brownColor
				//Change icon to list icon
				setIconAlpahToZero()
				self.listIconView.alpha = 1
				// Move list icon with drag
				var listIconPosition = CGFloat(self.convertValue(messageCenter, r1Min: -100, r1Max: -160, r2Min: 92, r2Max: 20))
				
				self.listIconView.center.x = listIconPosition
			}
			
			//Drag right for less than 60px
			else if (messageCenter > 160) && (messageCenter < 220) {
				setIconAlpahToZero()
				backgroundView.backgroundColor = grayColor
				
				//Convert message center position to opacity value
				var archiveIconOpacity = CGFloat(convertValue(messageCenter, r1Min: 175, r1Max: 220, r2Min: 0, r2Max: 1.0))
				
				//animate opacity change
				//				UIView.animateWithDuration(0.3, animations: {() -> Void in
				//					self.backgroundView.alpha = backgroundOpacity
				//				})
				self.archiveIconView.alpha = archiveIconOpacity
				
			}
				
				//Drag right for between 60px to 260px
			else if (messageCenter < 420) && (messageCenter > 220){
				setIconAlpahToZero()
				archiveIconView.alpha = 1
				// Change background to green
				self.backgroundView.backgroundColor = greenColor
				//Move later icon with the drag
				var archiveIconPosition = CGFloat(self.convertValue(messageCenter, r1Min: 220, r1Max: 420, r2Min: 32.5, r2Max: 227.5))
				
				self.archiveIconView.center.x = archiveIconPosition
				//				println(laterIconPosition)
				
			}
				
			else if (messageCenter > 420){
				setIconAlpahToZero()
				// Change background to red
				self.backgroundView.backgroundColor = redColor
				//Change icon to delete icon
				self.deleteIconView.alpha = 1
				// Move list icon with drag
				var deleteIconPosition = CGFloat(self.convertValue(messageCenter, r1Min: 420, r1Max: 480, r2Min: 227.5, r2Max: 287.5))
				
				self.deleteIconView.center.x = deleteIconPosition
			}
		}
		else if sender.state == UIGestureRecognizerState.Ended {
			//Drag left for less than 60px
			if (messageView.center.x > 100) && (messageView.center.x < 160) {
				UIView.animateWithDuration(0.3, animations: { () -> Void in
					self.messageView.center.x = 160
				})
			}
			//Drag left for more than 60px and less than 260px
			else if (messageView.center.x < 100) && (messageView.center.x > -100) {

				self.laterIconView.alpha = 0
				UIView.animateWithDuration(0.3, animations: { () -> Void in
					self.messageView.center.x = -160
				}, completion: { (Bool) -> Void in
					self.overlayButton.enabled = true
					self.delay(0.1, closure: { () -> () in
						UIView.animateWithDuration(0.3, animations: { () -> Void in
							self.rescheduleOptionOverlayView.alpha = 1
						})
					})
				})
				
			}
			else if (messageView.center.x < -100){
				self.laterIconView.alpha = 0
				self.listIconView.alpha = 0
				
				UIView.animateWithDuration(0.3, animations: { () -> Void in
					self.messageView.center.x = -160
					}, completion: { (Bool) -> Void in
						self.overlayButton.enabled = true
						self.delay(0.1, closure: { () -> () in
							UIView.animateWithDuration(0.3, animations: { () -> Void in
								self.listOptionOverlayView.alpha = 1
							})
						})
				})
		}
				
		//Drag right for less than 60px
		else if (messageView.center.x > 160) && (messageView.center.x < 220){
			UIView.animateWithDuration(0.3, animations: { () -> Void in
				self.messageView.center.x = 160
			})
		}
			
	//Drag right for between 60px to 260px
		else if (messageView.center.x > 220) && (messageView.center.x < 420){
			self.archiveIconView.alpha = 0
			UIView.animateWithDuration(0.3, animations: { () -> Void in
				self.messageView.center.x = 480
			}, completion: { (Bool) -> Void in
				UIView.animateWithDuration(0.5, animations: { () -> Void in
					self.messageContainerView.center.y -= 86
					self.feedView.center.y -= 86
				})
			})
		}
			
	//Drag right for more than 260px
		else if (messageView.center.x > 420) && (messageView.center.x < 480){
			self.deleteIconView.alpha = 0
			UIView.animateWithDuration(0.3, animations: { () -> Void in
				self.messageView.center.x = 480
			}, completion: { (Bool) -> Void in
				UIView.animateWithDuration(0.5, animations: { () -> Void in
					self.messageContainerView.center.y -= 86
					self.feedView.center.y -= 86
				})
			})
		}
			
//	println(messageView.center)
	}
}
	
	//Closing the overlay by tapping a hidden button
	@IBAction func didTapOverlay(sender: AnyObject) {
		UIView.animateWithDuration(0.3, animations: { () -> Void in
			self.rescheduleOptionOverlayView.alpha = 0
			self.listOptionOverlayView.alpha = 0
		})
		overlayButton.enabled = false
		
		//finish animation of moving up the message block
		UIView.animateWithDuration(0.5, animations: { () -> Void in
			self.messageContainerView.center.y -= 86
			self.feedView.center.y -= 86
		})
	}
	
	//Drag on scrollview return message to original position
	func scrollViewWillBeginDragging(scrollView: UIScrollView) {
		messageContainerView.center = messageContainerOrign
		messageView.center = messageInitial
//		println(messageView.center)
		backgroundView.backgroundColor = grayColor
		UIView.animateWithDuration(0.3, animations: { () -> Void in
		self.feedView.center.y = self.feedCenterOrigin.y
		})
	}
	
	
	func onEdgePan(edgeGesture: UIScreenEdgePanGestureRecognizer){
//		println("did swipe")
		var location = edgeGesture.locationInView(mailContainerView)
		var velocity = edgeGesture.velocityInView(mailContainerView)
		var translation = edgeGesture.translationInView(mailContainerView)
		
		if edgeGesture.state == UIGestureRecognizerState.Began{
			mailContainerOrigin = mailContainerView.center
		}
		else if edgeGesture.state == UIGestureRecognizerState.Changed{
			mailContainerView.center = CGPoint(x: translation.x + mailContainerOrigin.x, y: mailContainerOrigin.y)
		}
		else if edgeGesture.state == UIGestureRecognizerState.Ended {
			if (velocity.x >= 0){
				cancelButton.enabled = false
				UIView.animateWithDuration(0.5, animations: { () -> Void in
					self.mailContainerView.center.x = 440
				}, completion: { (Bool) -> Void in
					edgeGesture.enabled = false
					self.mailContainerPanGesture.enabled = true
				})
			}
			else {
				UIView.animateWithDuration(0.5, animations: { () -> Void in
					self.mailContainerView.center.x = 160
				})
			}
		}
	}
	
	
	@IBAction func didPressHamburger(sender: AnyObject) {
		UIView.animateWithDuration(0.3, animations: { () -> Void in
			self.mailContainerView.center.x = 160
		}) { (Bool) -> Void in
			self.mailContainerEdgeGesture.enabled = true
		}
		UIView.animateWithDuration(0.3, animations: { () -> Void in
			self.mailContainerView.center.x = 160
		})
		cancelButton.enabled = true
	}
	
	

	func onPanMailContainerView(mailContainerPanGesture: UIPanGestureRecognizer){
		
		var location = mailContainerPanGesture.locationInView(mailContainerView)
		var translation = mailContainerPanGesture.translationInView(mailContainerView)
		var velocity = mailContainerPanGesture.velocityInView(mailContainerView)
		
		if mailContainerPanGesture.state == UIGestureRecognizerState.Began{
			mailContainerOrigin = mailContainerView.center
		}
		else if mailContainerPanGesture.state == UIGestureRecognizerState.Changed{
			if velocity.x >= 0 {
				mailContainerView.center = mailContainerOrigin
			}
			else{
			mailContainerView.center = CGPoint(x: translation.x + mailContainerOrigin.x, y: mailContainerOrigin.y)
			}
		}
		else if mailContainerPanGesture.state == UIGestureRecognizerState.Ended{
			if velocity.x >= 0{
				
			}
			else {
				UIView.animateWithDuration(0.3, animations: { () -> Void in
					self.mailContainerView.center.x = 160
					}, completion: { (Bool) -> Void in
						self.mailContainerEdgeGesture.enabled = true
						mailContainerPanGesture.enabled = false
				})
			}
		}
	}

	
	//Compose button
	
	@IBAction func didTapComposeButton(sender: AnyObject) {
		hamburgerMenuButton.enabled = false
		self.toTextField.becomeFirstResponder()
		self.grayBackgroundView.alpha = 0.8
		UIView.animateWithDuration(0.5, animations: { () -> Void in
			self.composeView.center.y = 152
		})
	}
	
	
	@IBAction func tabChanged(sender: UISegmentedControl) {
		switch segementedControl.selectedSegmentIndex
		{
		case 0:
			yellowNavView.alpha = 1
			greenNavView.alpha = 0
			segementedControl.tintColor = yellowColor
			laterScreenView.alpha = 1
			if currentSegementedIndex == 1 {
				UIView.animateWithDuration(0.5, animations: { () -> Void in
					self.laterScreenView.center.x = 160
					self.scrollView.center.x = 480
				}, completion: { (Bool) -> Void in
				})
			}
			else if currentSegementedIndex == 2 {
				UIView.animateWithDuration(0.5, animations: { () -> Void in
					self.laterScreenView.center.x = 160
					self.archiveScreenView.center.x = 480
				}, completion: { (Bool) -> Void in
					self.setScreenPosition()
					self.laterScreenView.center.x = 160
				})
			}
			currentSegementedIndex = 0
			
		case 1:
			yellowNavView.alpha = 0
			greenNavView.alpha = 0
			segementedControl.tintColor = blueColor
			if currentSegementedIndex == 0{
				self.scrollView.center.x = 480
				UIView.animateWithDuration(0.5, animations: { () -> Void in
					self.scrollView.center.x = 160
					self.laterScreenView.center.x = -160
				}, completion: { (Bool) -> Void in
					self.setScreenPosition()
				})
			}
			else if currentSegementedIndex == 2 {
				self.scrollView.center.x = -160
				UIView.animateWithDuration(0.5, animations: { () -> Void in
					self.scrollView.center.x = 160
					self.archiveScreenView.center.x = 480
				}, completion: { (Bool) -> Void in
					self.setScreenPosition()
				})
			}
			currentSegementedIndex = 1
			

		case 2:
			yellowNavView.alpha = 0
			greenNavView.alpha = 1
			segementedControl.tintColor = greenColor
			self.archiveScreenView.center.x = 480
			if currentSegementedIndex == 0{
				UIView.animateWithDuration(0.5, animations: { () -> Void in
					self.archiveScreenView.center.x = 160
					self.laterScreenView.center.x = -160
				}, completion: { (Bool) -> Void in
					self.laterScreenView.alpha = 0
					self.setScreenPosition()
					self.archiveScreenView.center.x = 160
				})
			}
			else if currentSegementedIndex == 1{
				UIView.animateWithDuration(0.5, animations: { () -> Void in
					self.scrollView.center.x = -160
					self.archiveScreenView.center.x = 160
				}, completion: { (Bool) -> Void in
					self.laterScreenView.alpha = 0
					self.setScreenPosition()
					self.archiveScreenView.center.x = 160
				})
			}
			currentSegementedIndex = 2
		default:
			break;
		}
	}
	
	
	@IBAction func didPressCancelButton(sender: AnyObject) {
		toTextField.resignFirstResponder()
		actionSheet.showInView(view)
	}
	
	func dismissComposeView(){
		UIView.animateWithDuration(0.3, animations: { () -> Void in
			self.composeView.center.y = 702
		})
		delay(0.3, closure: { () -> () in
		})
		self.grayBackgroundView.alpha = 0
	}
	
	func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int){
		if buttonIndex == 0 {
			dismissComposeView()
			hamburgerMenuButton.enabled = true
		}
		else if buttonIndex == 2 {
			dismissComposeView()
			hamburgerMenuButton.enabled = true
		}
		else {
			
		}
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		self.becomeFirstResponder()
	}
	
	override func canBecomeFirstResponder() -> Bool {
		return true
	}
	

	override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
		if(event.subtype == UIEventSubtype.MotionShake) {
			var alertView = UIAlertView(title: "Undo last action?", message: "Are you sure you want to undo the last action?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Undo")
			alertView.show()
		}
	}

}
