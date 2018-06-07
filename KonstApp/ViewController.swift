//
//  ViewController.swift
//  KonstApp
//
//  Created by Kristin Rosen on 2018-02-22.
//  Copyright © 2018 Kristin Rosen and Fanny Erkhammar. All rights reserved.
//

import UIKit
import KontaktSDK

public enum UIButtonBorderSide {
    case Top, Bottom, Left, Right
}

//class for detail view for the artworks
class ViewController: UIViewController {
    
//    struct KonstverkData: Decodable {
//        let namn: String
//        let bild: String
//        let texter: [String]
//        let beaconMinor: String
//    }
    
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
    
    //ImageView
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bgImageView: UIImageView!
    
    //Activity Indicator
    
    
    //Label
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var textViewLabel: UITextView!
    
    @IBOutlet weak var textViewlabel2: UITextView!
    
    //Texts
    @IBOutlet weak var textView: UITextView!
    
    //Constants
    var konstverket: Konstverk?
    
    var konstverkTexter: KonstTexter?
    
    var displayString: String?
//    var infoTexts = [String]()
    
    var temaText: String?
    
    var IBMtext: String?
    
    override func viewWillAppear(_ animated: Bool) {
        
        //make font size adjust to accessibility settings
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        
//        textViewLabel.font = UIFont.preferredFont(forTextStyle: .body)
//        textViewLabel.adjustsFontForContentSizeCategory = true
//        
//        textViewlabel2.font = UIFont.preferredFont(forTextStyle: .body)
//        textViewlabel2.adjustsFontForContentSizeCategory = true
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("*VIEWCONTROLLER*")
        //print(konstverkTexter?.IBMKonstsamling as! String)
        
        //set button image views content mode to aspect fit
        button1.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        button2.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        button3.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        button1.addBorder(side: UIButtonBorderSide.Top, color: UIColor.lightGray, width: 0.2)
        button2.addBorder(side: UIButtonBorderSide.Top, color: UIColor.lightGray, width: 0.2)
        button3.addBorder(side: UIButtonBorderSide.Top, color: UIColor.lightGray, width: 0.2)
        
        // start activity indicator + hide image
//        imageView.isHidden = true
//        activityIndicatorView.hidesWhenStopped = true
//        activityIndicatorView.startAnimating()
        
        //add margins to text views
        textView.textContainerInset = UIEdgeInsetsMake(10, 10, 15, 10)
        
        textViewLabel.textContainerInset = UIEdgeInsetsMake(16, 10, 0, 10)
        
        textViewlabel2.textContainerInset = UIEdgeInsetsMake(0, 10, 5, 10)

        print("!-!-!-!-!-!-!-!-!-!")
        
        
        //Make sure konstverket isn't empty
        if konstverket?.title != nil {
//            if konstverket?.photo.size == CGSize(width: 0, height: 0) {
//                print("!!!!!!********bilden existerar inte********!!!!!!")
//                return } else {
            
            //Load texts and image from konstverket from startViewController
            print(konstverket!.photo)
            print([konstverket?.about])
            self.imageView.image = konstverket!.photo
//            self.activityIndicatorView.isHidden = true
//            self.imageView.isHidden = false
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
            
            
//            if konstverket!.beaconMajor == "17261" {
//                
//                self.temaText = (konstverkTexter?.temaTexter[0])!
//                print("vån \(temaText!)")
//                
//            } else if konstverket!.beaconMajor == "40314" {
//                
//                self.temaText = (konstverkTexter?.temaTexter[1])!
//                print("vån \(temaText!)")
//                
//            } else if konstverket!.beaconMajor == "40203" {
//                
//                self.temaText = (konstverkTexter?.temaTexter[2])!
//                print("vån \(temaText!)")
//                
//            }
//                
////             else if konstverket!.beaconMajor == "aaa" || konstverket!.beaconMajor == "4" {
////
////                self.temaText = (konstverkTexter?.temaTexter[3])!
////                print("vån \(temaText)")
////
////            }
//            else { print("okänd beacon major") }
//            
            
          
            
            
            
            print("!-!-!-!-!-!-!-!-!-!")
                
//            }
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
        //Make the first button selected and the proper color when you enter the viewController
        button1.isSelected = true
        button1.backgroundColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:0.8)


        
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
 
    
    //Change text + select corresponding buttons when tapping buttons (for all possible cases)
    
    /* LÄGG TILL SWIPEANIMATION vid knapptryck NÄR VI VET HUR MÅNGA KNAPPAR */
    
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
            textView.leftToRightAnimation()
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
            textView.leftToRightAnimation()
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
            textView.leftToRightAnimation()
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
            textView.rightToLeftAnimation()
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
            textView.rightToLeftAnimation()
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
            textView.rightToLeftAnimation()
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




