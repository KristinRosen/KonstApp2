//
//  ViewController.swift
//  KonstApp
//
//  Created by Kristin Rosen on 2018-02-22.
//  Copyright © 2018 Kristin Rosen and Fanny Erkhammar. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    
    //MARK: Properties
    @IBOutlet weak var textView: UITextView!
    
    var displayString: String?
    var infoTexts = ["Konstverk", "Konstnär", "Koppling till IBM"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Actions
    @IBAction func nextText(_ sender: UISwipeGestureRecognizer) {
        if displayString == nil {
        displayString = infoTexts[0]
        textView.leftToRightAnimation()
        textView.text = displayString
        } else if displayString == infoTexts[0] {
            displayString = infoTexts[1]
            textView.leftToRightAnimation()
            textView.text = displayString
        } else if displayString == infoTexts[1] {
            displayString = infoTexts[2]
            textView.leftToRightAnimation()
            textView.text = displayString
        } else {
            displayString = nil
            textView.text = displayString
            textView.leftToRightAnimation()
        }
    }
    
    @IBAction func previousText(_ sender: UISwipeGestureRecognizer) {
        if displayString == nil {
            displayString = infoTexts[2]
            textView.rightToLeftAnimation()
            textView.text = displayString
        } else if displayString == infoTexts[2] {
            displayString = infoTexts[1]
            textView.rightToLeftAnimation()
            textView.text = displayString
        } else if displayString == infoTexts[1] {
            displayString = infoTexts[0]
            textView.rightToLeftAnimation()
            textView.text = displayString
        } else {
            displayString = nil
            textView.rightToLeftAnimation()
            textView.text = displayString
        }
    }
    
}

extension UIView {
    func leftToRightAnimation(duration: TimeInterval = 0.5, completionDelegate: AnyObject? = nil) {
        // Create a CATransition object
        let leftToRightTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided
        if let delegate: AnyObject = completionDelegate {
            leftToRightTransition.delegate = delegate as? CAAnimationDelegate
            
        }
        
        leftToRightTransition.type = kCATransitionPush
        leftToRightTransition.subtype = kCATransitionFromRight
        leftToRightTransition.duration = duration
        leftToRightTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        leftToRightTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layernäm
        self.layer.add(leftToRightTransition, forKey: "leftToRightTransition")
        
    }
    
}

extension UIView {
    func rightToLeftAnimation(duration: TimeInterval = 0.5, completionDelegate: AnyObject? = nil) {
        // Create a CATransition object
        let rightToLeftTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided
        if let delegate: AnyObject = completionDelegate {
            rightToLeftTransition.delegate = delegate as? CAAnimationDelegate
            
        }
        
        rightToLeftTransition.type = kCATransitionPush
        rightToLeftTransition.subtype = kCATransitionFromLeft
        rightToLeftTransition.duration = duration
        rightToLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        rightToLeftTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layernäm
        self.layer.add(rightToLeftTransition, forKey: "rightToLeftTransition")
        
    }
    
}




