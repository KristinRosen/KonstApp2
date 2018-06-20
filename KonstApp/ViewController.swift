//
//  ViewController.swift
//  KonstApp
//
//  Created by Kristin Rosen on 2018-02-22.
//  Copyright © 2018 Kristin Rosen and Fanny Erkhammar. All rights reserved.
//

import UIKit
import KontaktSDK

//enables making extension for giving UIButton borders
public enum UIButtonBorderSide {
    case Top, Bottom, Left, Right
}

//class for detail view for the artworks
class ViewController: UIViewController {

    
    //MARK: Properties
    
    //Buttons
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    //ImageView
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bgImageView: UIImageView!
  
    //text view labels
    @IBOutlet weak var textViewLabel: UITextView!
    
    @IBOutlet weak var textViewlabel2: UITextView!
    
    //TextView
    @IBOutlet weak var textView: UITextView!
    
    
    //Variables
    
    //Konstverk class object used to pass data from previous view
    var konstverket: Konstverk?
    
    //KonstTexter class object used to pass data from previous view
    var konstverkTexter: KonstTexter?
    
    //the text which is currently displayed in the textView
    var displayString: String?
    
    //the "temaText" for the currently displayed artwork
    var temaText: String?
    
    //text about the art collection (same text for all artworks)
    var IBMtext: String?
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        //make font size adjust to accessibility settings
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set button image views content mode to aspect fit and add top borders
        button1.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        button2.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        button3.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        button1.addBorder(side: UIButtonBorderSide.Top, color: UIColor.lightGray, width: 0.5)
        button2.addBorder(side: UIButtonBorderSide.Top, color: UIColor.lightGray, width: 0.5)
        button3.addBorder(side: UIButtonBorderSide.Top, color: UIColor.lightGray, width: 0.5)
        
        //add margins to text views
        textView.textContainerInset = UIEdgeInsetsMake(10, 10, 15, 10)
        
        textViewLabel.textContainerInset = UIEdgeInsetsMake(16, 10, 0, 10)
        
        textViewlabel2.textContainerInset = UIEdgeInsetsMake(0, 10, 5, 10)
        
        //Make sure konstverket isn't empty
        if konstverket?.title != nil {
            
            //Load texts and image from konstverket from startViewController
            print(konstverket!.photo)
            print([konstverket?.about])
            self.imageView.image = konstverket!.photo
            
            self.bgImageView.image = konstverket!.photo
            self.title = konstverket!.title
            self.textViewLabel.text = konstverket!.title
            self.textViewlabel2.text = konstverket!.artistName
            self.IBMtext = (konstverkTexter?.IBMKonstsamling)!
            
            //set the first page's textView text (that is shown when you enter the viewController)
            self.displayString = konstverket!.about
            self.textView.text = displayString
            
            //Find index of "konstverket"'s beaconMajor in downloaded list of beacon majors
            let majorIndex = konstverket!.beaconMajor
            let i4 = konstverkTexter?.beaconMajorValues.index(of: majorIndex)
            
            
            //find the "temaText" with the same index as beaconMajor in the downloaded array "temaTexter" = "temaText" for the right floor
            if i4 != nil {
                self.temaText = (konstverkTexter?.temaTexter[i4!])!
                print("vån \(temaText!)")
            } else {
                self.temaText = "Ingen våning registrerad för konstverket"
            }
        
        } else {print("temaText error")}
        
        //Make the first button selected and the proper color when you enter the viewController
        button1.isSelected = true
        button1.backgroundColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:0.8)
        
    }
    
    
    //Change text + select corresponding buttons when tapping buttons (for all possible cases)
    
    @IBAction func showText1(_ sender: UIButton) {
        displayString = konstverket!.about
        textView.text = displayString
        button1.isSelected = true
        button2.isSelected = false
        button3.isSelected = false
        
        button1.backgroundColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:0.8)
        button2.backgroundColor = .white
        button3.backgroundColor = .white
        
    }
    @IBAction func showText2(_ sender: UIButton) {
        displayString = temaText
        textView.text = displayString
        button1.isSelected = false
        button2.isSelected = true
        button3.isSelected = false
        
        button1.backgroundColor = .white
        button2.backgroundColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:0.8)
        button3.backgroundColor = .white
    }
    @IBAction func showText3(_ sender: UIButton) {
        displayString = IBMtext
        textView.text = displayString
        button1.isSelected = false
        button2.isSelected = false
        button3.isSelected = true
        
        button1.backgroundColor = .white
        button2.backgroundColor = .white
        button3.backgroundColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:0.8)
    }
    
    
    
    // Change text + select corresponding button when swiping
    //...to the right
    @IBAction func nextText(_ sender: UISwipeGestureRecognizer) {
        if displayString == konstverket!.about {
            displayString = temaText
            textView.rightToLeftAnimation()
            textView.text = displayString
            button1.isSelected = false
            button2.isSelected = true
            button3.isSelected = false
            
            button1.backgroundColor = .white
            button2.backgroundColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:0.8)
            button3.backgroundColor = .white
            
        }
        else if displayString == temaText {
            displayString = IBMtext
            textView.rightToLeftAnimation()
            textView.text = displayString
            button1.isSelected = false
            button2.isSelected = false
            button3.isSelected = true
            
            button1.backgroundColor = .white
            button2.backgroundColor = .white
            button3.backgroundColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:1.0)
        }
            
        else {
            displayString = konstverket!.about
            textView.text = displayString
            textView.rightToLeftAnimation()
            button1.isSelected = true
            button2.isSelected = false
            button3.isSelected = false
            
            button1.backgroundColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:0.8)
            button2.backgroundColor = .white
            button3.backgroundColor = .white
        }
    }
    
    //...to the left
    @IBAction func previousText(_ sender: UISwipeGestureRecognizer) {
        if displayString == konstverket!.about {
            displayString = IBMtext
            textView.leftToRightAnimation()
            textView.text = displayString
            button1.isSelected = false
            button2.isSelected = false
            button3.isSelected = true
            
            button1.backgroundColor = .white
            button2.backgroundColor = .white
            button3.backgroundColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:0.8)
        }
        else if displayString == IBMtext {
            displayString = temaText
            textView.leftToRightAnimation()
            textView.text = displayString
            button1.isSelected = false
            button2.isSelected = true
            button3.isSelected = false
            
            button1.backgroundColor = .white
            button2.backgroundColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:0.8)
            button3.backgroundColor = .white
            
        }
            
        else {
            displayString = konstverket!.about
            textView.leftToRightAnimation()
            textView.text = displayString
            button1.isSelected = true
            button2.isSelected = false
            button3.isSelected = false
            
            button1.backgroundColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:0.8)
            button2.backgroundColor = .white
            button3.backgroundColor = .white
        }
    }
    
}

//Swipe animation
extension UIView {
    public func rightToLeftAnimation(duration: TimeInterval = 0.5, completionDelegate: AnyObject? = nil) {
        // Create a CATransition object
        let rightToLeftTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided
        if let delegate: AnyObject = completionDelegate {
            rightToLeftTransition.delegate = delegate as? CAAnimationDelegate
            
        }
        
        rightToLeftTransition.type = kCATransitionPush
        rightToLeftTransition.subtype = kCATransitionFromRight
        rightToLeftTransition.duration = duration
        rightToLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        rightToLeftTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layernäm
        self.layer.add(rightToLeftTransition, forKey: "rightToLeftTransition")
        
    }
    
}

extension UIView {
    public func leftToRightAnimation(duration: TimeInterval = 0.5, completionDelegate: AnyObject? = nil) {
        // Create a CATransition object
        let leftToRightTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided
        if let delegate: AnyObject = completionDelegate {
            leftToRightTransition.delegate = delegate as? CAAnimationDelegate
            
        }
        
        leftToRightTransition.type = kCATransitionPush
        leftToRightTransition.subtype = kCATransitionFromLeft
        leftToRightTransition.duration = duration
        leftToRightTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        leftToRightTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        self.layer.add(leftToRightTransition, forKey: "leftToRightTransition")
        
    }
    
}

extension UIButton {
    
    public func addBorder(side: UIButtonBorderSide, color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        
        switch side {
        case .Top:
            border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
        case .Bottom:
            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        case .Left:
            border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        case .Right:
            border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        }
        
        self.layer.addSublayer(border)
    }
}




