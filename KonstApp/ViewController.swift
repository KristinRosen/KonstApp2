//
//  ViewController.swift
//  KonstApp
//
//  Created by Kristin Rosen on 2018-02-22.
//  Copyright © 2018 Kristin Rosen and Fanny Erkhammar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Check if image has been downloaded earlier during the same session
    var didDownload = Bool()
    
    //check if image named "image.jpeg" has previosly been saved to UserDefaults
    func checkIfDownloaded() -> Bool {
        if (UserDefaults.standard.object(forKey: "image.jpeg") != nil) {
            print("image has previously been downloaded")
            return true
        } else {
            print("image not yet downloaded")
            return false
        }
    }
    
    
    //MARK: Properties
 
    //Buttons
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    //ImageView
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bgImageView: UIImageView!
    
    //Activity Indicator
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    //Texts
    @IBOutlet weak var textView: UITextView!
    
    var displayString: String?
    var infoTexts = ["Konstverk hurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfvhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfKonstverk hurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfvhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfKonstverk hurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfvhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdfhurhejhlkhfjhgsfdf", "Konstnär", "Koppling till IBM"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        button1.isSelected = true
        
        //run check if downloaded function (kanske överflödig)
        checkIfDownloaded()
        
        //Set url for image + start activity indicator + hide image
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.startAnimating()
        self.imageView.isHidden = true
        if let url = URL(string: "url") {
            
            //if image has previously been downloaded during the same session or previous session, load image from Userdefaults
            if didDownload == true || checkIfDownloaded() == true {
                
                let newData = UserDefaults.standard.object(forKey: "image.jpeg") as! NSData
                
                self.imageView.image = UIImage(data: newData as Data)
                self.bgImageView.image = UIImage(data: newData as Data)
                self.activityIndicatorView.stopAnimating()
                self.imageView.isHidden = false
                
                print("image loaded from memory")
                
            //Otherwise download and save image to UserDefaults
            } else {
                
                downloadImage(url: url)
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Actions
    
    //Get image from url + stop activity indicator + show image
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        print("Started downloading")

        getDataFromUrl(url: url) {
            data, response, error in
            guard let data = data, error == nil else { return }
            
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Finished downloading")
            DispatchQueue.main.async() {
                
                let dataREP = UIImageJPEGRepresentation(UIImage(data: data)!, 1.0)
                
                UserDefaults.standard.set(dataREP, forKey: "image.jpeg")
                
                let newData = UserDefaults.standard.object(forKey: "image.jpeg") as! NSData
                
                self.imageView.image = UIImage(data: newData as Data)
                self.bgImageView.image = UIImage(data: newData as Data)
                self.activityIndicatorView.stopAnimating()
                self.imageView.isHidden = false
                
                self.didDownload = true
                
                print("image downloaded and saved")
                
            }
        }
        
    }
    
    //activity indicator
    /*
    func showActivityIndicator() {
        if {
            self.activityIndicatorView.isHidden = true
            self.imageView.isHidden = false
            self.activityIndicatorView.stopAnimating()
        } else {
            self.activityIndicatorView.isHidden = false
            self.imageView.isHidden = true
            self.activityIndicatorView.startAnimating()
        }
    }
 */
    
    
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
        
        // Add the animation to the View's layer
        self.layer.add(rightToLeftTransition, forKey: "rightToLeftTransition")
        
    }
    
}





