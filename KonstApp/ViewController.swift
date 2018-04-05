//
//  ViewController.swift
//  KonstApp
//
//  Created by Kristin Rosen on 2018-02-22.
//  Copyright © 2018 Kristin Rosen and Fanny Erkhammar. All rights reserved.
//

import UIKit








class ViewController: UIViewController {
    
    struct KonstverkData: Decodable {
        let namn: String
        let bild: String
        let texter: [String]
    }
    
   var bildUrl = String()
    
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
    
    //Label
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var textViewLabel: UITextView!
    
    @IBOutlet weak var textViewlabel2: UITextView!
    
    //Texts
    @IBOutlet weak var textView: UITextView!
    
    var konstverket: Konstverk?
    
    var displayString: String?
//    var infoTexts = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        //set button image views to aspect fit
        button1.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        button2.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        button3.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        button4.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        // start activity indicator + hide image
        imageView.isHidden = true
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.startAnimating()
        
        //add margins to text views
        textView.textContainerInset = UIEdgeInsetsMake(15, 10, 15, 10)
        
        textViewLabel.textContainerInset = UIEdgeInsetsMake(10, 10, 0, 10)
        
        textViewlabel2.textContainerInset = UIEdgeInsetsMake(0, 10, 10, 10)

        print("!-!-!-!-!-!-!-!-!-!")
        
        if konstverket?.title != nil {
            print(konstverket!.photo)
            print([konstverket?.about])
            self.imageView.image = konstverket!.photo
            self.activityIndicatorView.isHidden = true
            self.imageView.isHidden = false
            self.bgImageView.image = konstverket!.photo
            self.title = konstverket!.title
            self.textViewLabel.text = konstverket!.title
            
            self.displayString = konstverket!.about[0]
            self.textView.text = displayString
            
            print("!-!-!-!-!-!-!-!-!-!")
        } else {print("error")}
        
//    //Fetching JSONobject from url
//
//        let jsonUrlString = "http://localhost:6001/konstverk"
//        guard let url = URL(string: jsonUrlString) else
//        { return }
//
//        URLSession.shared.dataTask(with: url) { (data, response, err) in
//            //perhaps check err
//            //also perhaps check response status 200 OK
//
//            guard let data = data else { return }
//
//
//           do {
//
//            //decode data + print namn
//            let konstverkData = try JSONDecoder().decode([KonstverkData].self, from: data)
//                print(konstverkData[0].namn)
//                print(konstverkData[0].bild)
//                print(konstverkData[0].texter)
//
//            DispatchQueue.main.async {
//                self.textViewLabel.text = konstverkData[0].namn
//                self.infoTexts = konstverkData[0].texter
//                self.displayString = self.infoTexts[0]
//                self.textView.text = self.displayString
//
//            }
//                self.bildUrl = konstverkData[0].bild
//
//
//
//
//            //Set url for image
//
//                if let url = URL(string: self.bildUrl) {
//
//                //if image has previously been downloaded during the same session or previous session, load image from Userdefaults
//                //            if didDownload == true || checkIfDownloaded() == true {
//                //
//                //                let newData = UserDefaults.standard.object(forKey: "image.jpeg") as! NSData
//                //
//                //                self.imageView.image = UIImage(data: newData as Data)
//                //                self.bgImageView.image = UIImage(data: newData as Data)
//                //                self.activityIndicatorView.stopAnimating()
//                //                self.imageView.isHidden = false
//                //
//                //                print("image loaded from memory")
//                //
//                //            //Otherwise download and save image to UserDefaults
//                //            } else {
//                //
//                print("Hej")
//                self.downloadImage(url: url)
//                //            }
//            }
//
//            } catch let jsonErr {
//                print(jsonErr)
//            }
//        }.resume()
//
//
//
//
        button1.isSelected = true
        button1.backgroundColor = UIColor(white: 1, alpha: 0.7)


        
//
//
//    }
//
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    //MARK: Actions
//
//    //Get image from url + stop activity indicator + show image
//    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            completion(data, response, error)
//            }.resume()
//    }
//
//    func downloadImage(url: URL) {
//        print("Started downloading")
//
//        getDataFromUrl(url: url) {
//            data, response, error in
//            guard let data = data, error == nil else { return }
//
//            print(response?.suggestedFilename ?? url.lastPathComponent)
//            print("Finished downloading")
//            DispatchQueue.main.async() {
//
//                let dataREP = UIImageJPEGRepresentation(UIImage(data: data)!, 1.0)
//
//                UserDefaults.standard.set(dataREP, forKey: "image.jpeg")
//
//                let newData = UserDefaults.standard.object(forKey: "image.jpeg") as! NSData
//
//                self.imageView.image = UIImage(data: newData as Data)
//                self.bgImageView.image = UIImage(data: newData as Data)
//                self.activityIndicatorView.stopAnimating()
//                self.imageView.isHidden = false
//
//                self.didDownload = true
//
//                print("image downloaded and saved")
//
//            }
//        }
//
        
        
  }
 
    
    
    
    
    //Change text + select corresponding buttons when tapping buttons
    
    /* LÄGG TILL SWIPEANIMATION vid knapptryck NÄR VI VET HUR MÅNGA KNAPPAR */
    
    @IBAction func showText1(_ sender: UIButton) {
        displayString = konstverket!.about[0]
        textView.text = displayString
        button1.isSelected = true
        button2.isSelected = false
        button3.isSelected = false
        button4.isSelected = false
        
        button1.backgroundColor = UIColor(white: 1, alpha: 0.7)
        button2.backgroundColor = .white
        button3.backgroundColor = .white
        button4.backgroundColor = .white

    }
    @IBAction func showText2(_ sender: UIButton) {
        displayString = konstverket!.about[1]
        textView.text = displayString
        button1.isSelected = false
        button2.isSelected = true
        button3.isSelected = false
        button4.isSelected = false
        
        button1.backgroundColor = .white
        button2.backgroundColor = UIColor(white: 1, alpha: 0.7)
        button3.backgroundColor = .white
        button4.backgroundColor = .white
    }
    @IBAction func showText3(_ sender: UIButton) {
        displayString = konstverket!.about[2]
        textView.text = displayString
        button1.isSelected = false
        button2.isSelected = false
        button3.isSelected = true
        button4.isSelected = false
        
        button1.backgroundColor = .white
        button2.backgroundColor = .white
        button3.backgroundColor = UIColor(white: 1, alpha: 0.7)
        button4.backgroundColor = .white
    }
    @IBAction func showText4(_ sender: UIButton) {
        displayString = konstverket!.about[3]
        textView.text = displayString
        button1.isSelected = false
        button2.isSelected = false
        button3.isSelected = false
        button4.isSelected = true
        
        button1.backgroundColor = .white
        button2.backgroundColor = .white
        button3.backgroundColor = .white
        button4.backgroundColor = UIColor(white: 1, alpha: 0.7)
    }
    
    
    // Change text + select corresponding button when swiping
    @IBAction func nextText(_ sender: UISwipeGestureRecognizer) {
        if displayString == konstverket!.about[0] {
        displayString = konstverket!.about[1]
        textView.leftToRightAnimation()
        textView.text = displayString
        button1.isSelected = false
        button2.isSelected = true
        button3.isSelected = false
        button4.isSelected = false
            
            button1.backgroundColor = .white
            button2.backgroundColor = UIColor(white: 1, alpha: 0.7)
            button3.backgroundColor = .white
            button4.backgroundColor = .white

        }
        else if displayString == konstverket!.about[1] {
            displayString = konstverket!.about[2]
            textView.leftToRightAnimation()
            textView.text = displayString
            button1.isSelected = false
            button2.isSelected = false
            button3.isSelected = true
            button4.isSelected = false
            
            button1.backgroundColor = .white
            button2.backgroundColor = .white
            button3.backgroundColor = UIColor(white: 1, alpha: 0.7)
            button4.backgroundColor = .white
        }
        else if displayString == konstverket!.about[2] {
            displayString = konstverket!.about[3]
            textView.leftToRightAnimation()
            textView.text = displayString
            button1.isSelected = false
            button2.isSelected = false
            button3.isSelected = false
            button4.isSelected = true
            
            button1.backgroundColor = .white
            button2.backgroundColor = .white
            button3.backgroundColor = .white
            button4.backgroundColor = UIColor(white: 1, alpha: 0.7)
        }
        
        else {
            displayString = konstverket!.about[0]
            textView.text = displayString
            textView.leftToRightAnimation()
            button1.isSelected = true
            button2.isSelected = false
            button3.isSelected = false
            button4.isSelected = false
            
            button1.backgroundColor = UIColor(white: 1, alpha: 0.7)
            button2.backgroundColor = .white
            button3.backgroundColor = .white
            button4.backgroundColor = .white
        }
    }
    
    @IBAction func previousText(_ sender: UISwipeGestureRecognizer) {
        if displayString == konstverket!.about[0] {
            displayString = konstverket!.about[3]
            textView.rightToLeftAnimation()
            textView.text = displayString
            button1.isSelected = false
            button2.isSelected = false
            button3.isSelected = false
            button4.isSelected = true

            button1.backgroundColor = .white
            button2.backgroundColor = .white
            button3.backgroundColor = .white
            button4.backgroundColor = UIColor(white: 1, alpha: 0.7)
        }
        else if displayString == konstverket!.about[3] {
            displayString = konstverket!.about[2]
            textView.rightToLeftAnimation()
            textView.text = displayString
            button1.isSelected = false
            button2.isSelected = false
            button3.isSelected = true
            button4.isSelected = false
            
            button1.backgroundColor = .white
            button2.backgroundColor = .white
            button3.backgroundColor = UIColor(white: 1, alpha: 0.7)
            button4.backgroundColor = .white
        }
        else if displayString == konstverket!.about[2] {
            displayString = konstverket!.about[1]
            textView.rightToLeftAnimation()
            textView.text = displayString
            button1.isSelected = false
            button2.isSelected = true
            button3.isSelected = false
            button4.isSelected = false
            
            button1.backgroundColor = .white
            button2.backgroundColor = UIColor(white: 1, alpha: 0.7)
            button3.backgroundColor = .white
            button4.backgroundColor = .white

        }
        
        else {
            displayString = konstverket!.about[0]
            textView.rightToLeftAnimation()
            textView.text = displayString
            button1.isSelected = true
            button2.isSelected = false
            button3.isSelected = false
            button4.isSelected = false
            
            button1.backgroundColor = UIColor(white: 1, alpha: 0.7)
            button2.backgroundColor = .white
            button3.backgroundColor = .white
            button4.backgroundColor = .white
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







