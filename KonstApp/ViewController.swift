//
//  ViewController.swift
//  KonstApp
//
//  Created by Kristin Rosen on 2018-02-22.
//  Copyright © 2018 Kristin Rosen and Fanny Erkhammar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    //MARK: Properties
 
    //Buttons
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    //ImageView
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bgImageView: UIImageView!
    
    
    //Texts
    @IBOutlet weak var textView: UITextView!
    
    var displayString: String?
    var infoTexts = ["Konstverk hurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfvhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfKonstverk hurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfvhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfKonstverk hurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfvhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdf", "Konstnär", "Koppling till IBM"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        button1.isSelected = true
        
        
        //Image
        print("Begin of code")
        if let url = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/66/VanGogh-starry_night_ballance1.jpg/600px-VanGogh-starry_night_ballance1.jpg") {
            downloadImage(url: url)
        }
        print("End of code. The image will continue downloading in the background and it will be loaded when it ends.")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Actions
    
    //Get image from url
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) {
            data, response, error in
            guard let data = data, error == nil else { return }
            
            print(response?.suggestedFilename ?? url.lastPathComponent)
            
            print("Download Finished")
            DispatchQueue.main.async() {
                self.imageView.image = UIImage(data: data)
                self.bgImageView.image = UIImage(data: data)
            }
        }
    }
    
    
       
    
    //Change text + select corresponding buttons when tapping buttons
    
    /* LÄGG TILL SWIPEANIMATION vid knapptryck NÄR VI VET HUR MÅNGA KNAPPAR */
    
    @IBAction func showText1(_ sender: UIButton) {
        displayString = nil
        textView.text = displayString
        button1.isSelected = true
        button2.isSelected = false
        button3.isSelected = false
        button4.isSelected = false
        
    }
    @IBAction func showText2(_ sender: UIButton) {
        displayString = infoTexts[0]
        textView.text = displayString
        button1.isSelected = false
        button2.isSelected = true
        button3.isSelected = false
         button4.isSelected = false
    }
    @IBAction func showText3(_ sender: UIButton) {
        displayString = infoTexts[1]
        textView.text = displayString
        button1.isSelected = false
        button2.isSelected = false
        button3.isSelected = true
         button4.isSelected = false
    }
    @IBAction func showText4(_ sender: UIButton) {
        displayString = infoTexts[2]
        textView.text = displayString
        button1.isSelected = false
        button2.isSelected = false
        button3.isSelected = false
        button4.isSelected = true
    }
    
    
    // Change text + select corresponding button when swiping
    @IBAction func nextText(_ sender: UISwipeGestureRecognizer) {
        if displayString == nil {
        displayString = infoTexts[0]
        textView.leftToRightAnimation()
        textView.text = displayString
        button1.isSelected = false
        button2.isSelected = true
        button3.isSelected = false
        button4.isSelected = false
        }
        else if displayString == infoTexts[0] {
            displayString = infoTexts[1]
            textView.leftToRightAnimation()
            textView.text = displayString
            button1.isSelected = false
            button2.isSelected = false
            button3.isSelected = true
            button4.isSelected = false
        }
        else if displayString == infoTexts[1] {
            displayString = infoTexts[2]
            textView.leftToRightAnimation()
            textView.text = displayString
            button1.isSelected = false
            button2.isSelected = false
            button3.isSelected = false
            button4.isSelected = true
        }
        else {
            displayString = nil
            textView.text = displayString
            textView.leftToRightAnimation()
            button1.isSelected = true
            button2.isSelected = false
            button3.isSelected = false
            button4.isSelected = false
        }
    }
    
    @IBAction func previousText(_ sender: UISwipeGestureRecognizer) {
        if displayString == nil {
            displayString = infoTexts[2]
            textView.rightToLeftAnimation()
            textView.text = displayString
            button1.isSelected = false
            button2.isSelected = false
            button3.isSelected = false
            button4.isSelected = true
        }
        else if displayString == infoTexts[2] {
            displayString = infoTexts[1]
            textView.rightToLeftAnimation()
            textView.text = displayString
            button1.isSelected = false
            button2.isSelected = false
            button3.isSelected = true
            button4.isSelected = false
        }
        else if displayString == infoTexts[1] {
            displayString = infoTexts[0]
            textView.rightToLeftAnimation()
            textView.text = displayString
            button1.isSelected = false
            button2.isSelected = true
            button3.isSelected = false
            button4.isSelected = false
        }
        else {
            displayString = nil
            textView.rightToLeftAnimation()
            textView.text = displayString
            button1.isSelected = true
            button2.isSelected = false
            button3.isSelected = false
            button4.isSelected = false
        }
    }
    
}

//Animation
extension UIView {
    public func leftToRightAnimation(duration: TimeInterval = 0.5, completionDelegate: AnyObject? = nil) {
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
    public func rightToLeftAnimation(duration: TimeInterval = 0.5, completionDelegate: AnyObject? = nil) {
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




