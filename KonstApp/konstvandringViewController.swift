//
//  konstvandringViewController.swift
//  KonstApp
//
//  Created by Fanny Erkhammar on 2018-05-16.
//  Copyright © 2018 Kristin Rosen and Fanny Erkhammar. All rights reserved.
//

import UIKit
import KontaktSDK

var isRanging = Bool()
//var beaconMinor = CLBeaconMinorValue(1)

//structure used to decode json objects "konstverk"
struct KonstverkData4: Decodable {
    let namn: String
    let konstnar: String
    let bild: String
    let texter: String
    let beaconMinor: String
    let beaconMajor: String
}

//structure used to decode json object "konstTexter"
struct KonstTextData: Decodable {
    let IBMkonstsamling: String
    let temaTexter: [String]
    let beaconMajorValues: [String]
    let startBild: String
}


//index value
var i = Int()

//beacons that don't have 0 as rssi value
var validBeacons = [CLBeacon]()

//array uset to sort out bacons with 0 as rssi value, and later save the other ones to validBeacons
var validBeacons2 = [CLBeacon]()

//KonstTexter class objects used to get pass from previous view
var konstverkTexter: KonstTexter?

//array containing rssi values of found beacons
var beaconDistance = [Int]()

//minor value of the closest beacon
var closestBeaconMinor = String()

var displayString: String?

var verkText: String?

var temaText: String?

var IBMtext: String?

//var theOneAndOnly = Beacon(minor: "0", major: "0", distance: 0)
//var beaconens = [Beacon(minor: "", major: "", distance: 1)]
//var beaconen = Beacon(minor: "0", major: "0", distance: 0)


class konstvandringViewController: UIViewController, CLLocationManagerDelegate {
    
    
    //MARK: Properties
    
    //OUTLETS
    
    //stack view containting stackView
  //  @IBOutlet weak var storStackView: UIStackView!
    
        @IBOutlet weak var stackView: UIStackView!
    
            //lable displaying closest artwork name
    @IBOutlet weak var titelLabel: UITextView!
    @IBOutlet weak var konstnarLabel: UITextView!
    
    @IBOutlet weak var textView: UITextView!
    
//            @IBOutlet weak var showDetailButton: UIButton!
    
            @IBOutlet weak var imageView: UIImageView!
    
            @IBOutlet weak var bgImageView: UIImageView!
    
  
    //view containting placeholder animation and text
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var animationImageView: UIImageView!
    @IBOutlet weak var placeholderText: UITextView!
    
    //scroll view
    @IBOutlet weak var scrollView: UIScrollView!
    
    //stack view with buttons
    @IBOutlet weak var buttonStackView: UIStackView!
    
    //Buttons
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    
    
    //CONSTANTS AND VARIABLES
    
    //placeholder animation
    let animation = UIImage.animatedImage(with: [#imageLiteral(resourceName: "signal1"), #imageLiteral(resourceName: "signal2"), #imageLiteral(resourceName: "signal3"), #imageLiteral(resourceName: "signal4")], duration: 1.5)
    
//    //Images class object used to pass images from previous view
//    var konstBilder = Images(konstBild: [UIImage()])
//
    //Konstverk class object used to pass "konstverk" object to the next view
    var beaconKonstverk = Konstverk(title: "", artistName: "", photo: nil, about: "", beaconMinor: "", beaconMajor: "")
    
    var beaconManager: KTKBeaconManager!
    
    // minor och major hämtade från beacons
    //minor
    //var beaconArray = [String]()
    
    //major value of closest beacon
    var beaconArray2 = String()
    
    //aray of downloaded titles
    var konstName = [String]()
    
    //array of downloaded artist names
    var konstnarName = [String]()
    
    //array of downloaded image urls
    var bildUrl = [String]()
    
    //array of downloaded images
    var konstBild = [UIImage()]
    
    //array of downloaded info texts
    var konstTexter = [String]()
    
    //array of downloaded minor values
    var beaconMinorValues = [String]()
    
    //array of downloaded major values
    var beaconMajorValues = [String]()
    
    //array of all downloaded image urls
    var bildUrl2 = [URL]()
    
    var bildDictionary = [URL: UIImage]()
    
    var keyList:[URL] {
        get{
            return [URL](self.bildDictionary.keys)
        }
    }
    
    var cellArray = [UIImage]()
    
    var myRowKey: URL!
    var myRowData = UIImage()
    
    var beaconImage = [UIImage]()
    var beaconUrl  = String()
    var beaconTexts = String()
    var beaconName = String()
    var beaconArtist = String()
    var beaconBEACON = String()
    //var beaconBild = String()
    var beaconBEACONBEACON = String()
    
    var beaconBilden = UIImage()
    
    
    
    
    
    //MARK: VIEW VILL APPEAR__________!!!!!!!!!___________!!!!!!!!!_________!!!!!!!!_________!!!!!!!!!
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        //Show the navigation bar in this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        //hide stack view and show placeholder when view appears
//        showDetailButton.isHidden = true
//        storStackView.isHidden = true
        scrollView.isHidden = true
        buttonStackView.isHidden = true
        placeholderView.isHidden = false
        
        //set placeholder text + text size
        let normalText2 = "Letar efter konstverk..."
        let attribute3 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20)]
        let normalString2 = NSMutableAttributedString(string: normalText2, attributes: attribute3)
        
        //set label text to placeholder text + center label text + set text color
        placeholderText.attributedText = normalString2
        placeholderText.textAlignment = NSTextAlignment.center
        placeholderText.textColor = .gray
        
        //remove any images
        imageView.image = nil
        bgImageView.image = nil
        
        //imageView.contentMode = UIViewContentMode.bottom
        
        
        animationImageView.image = animation
        
//        showDetailButton.backgroundColor = .white
//        showDetailButton.layer.cornerRadius = 4
        
        //stackView.setCustomSpacing(10, after: showDetailLabel)
        
//        //add vertical space between rows in showDetailLabel
//        let verticalSpace = NSLayoutConstraint(item: showDetailLabel, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: showDetailLabel, attribute: .top, multiplier: 1, constant: 20)
//        NSLayoutConstraint.activate([verticalSpace])
        
        //add margins to text views
        textView.textContainerInset = UIEdgeInsetsMake(10, 10, 15, 10)
        
        titelLabel.textContainerInset = UIEdgeInsetsMake(16, 10, 0, 10)
        
        konstnarLabel.textContainerInset = UIEdgeInsetsMake(0, 10, 5, 10)
        
        //reset beacon minor & major values
        print("REMOVE BEACONS")
        validBeacons.removeAll()
        //beaconArray.removeAll()
        cellArray.removeAll()
//        beaconArray2.removeAll()
        print("BEACONS REMOVED")
        
       
        
        
        //MARK: Download from url
        
        
        
        //        //download session 1
        //        //url which the "konstverk" objects are downloaded from
        //        let jsonUrlString = "https://konstapptest.eu-gb.mybluemix.net/konstverk"
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
        //            do {
        //
        //                //decode konstverkData
        //                let konstverkData = try JSONDecoder().decode([KonstverkData4].self, from: data)
        //                print(konstverkData[0].namn)
        //                print(konstverkData[0].bild)
        //                print(konstverkData[0].texter)
        //                print(konstverkData[0].beaconMinor)
        //
        //
        //                //add strings to arrays
        //                for namn in konstverkData {
        //                    print("Found \(namn.namn)")
        //                    print("Found \(namn.konstnar)")
        //                    print("Found \(namn.texter)")
        //                    print("Found \(namn.beaconMinor)")
        //                    self.konstName.append(namn.namn)
        //                    self.konstnarName.append(namn.konstnar)
        //                    self.konstTexter.append(namn.texter)
        //                    self.beaconMinorValues.append(namn.beaconMinor)
        //                    self.bildUrl.append(namn.bild)
        //
        //
        //
        //                    //                    if let url = URL(string: namn.bild) {
        //                    //
        //                    //                        print("kladdkaka2")
        //                    //                        self.downloadImage(url: url)
        //                    //
        //                    //                            }
        //                }
        //
        //
        //
        //
        //            } catch let jsonErr {
        //                print(jsonErr)
        //            }
        //            }.resume()
        //        //end of download session 1
        
        
        //download session 2
        //url which the "konstTexter" object is downloaded from
        let jsonUrlString2 = "https://konstapptest.eu-gb.mybluemix.net/konstTexter"
        guard let url2 = URL(string: jsonUrlString2) else
        { return }
        
        URLSession.shared.dataTask(with: url2) { (data, response, err) in
            //perhaps check err
            //also perhaps check response status 200 OK
            
            guard let data = data else { return }
            
            
            do {
                
                //decode konstTextData
                let konstverkData2 = try JSONDecoder().decode([KonstTextData].self, from: data)
                print(konstverkData2[0].IBMkonstsamling)
                print(konstverkData2[0].temaTexter)
                print(konstverkData2[0].beaconMajorValues)
                
                
                //add values to KonstTexter class object "konstverkTexter"
                konstverkTexter = KonstTexter(IBMKonstsamling: konstverkData2[0].IBMkonstsamling, temaTexter: konstverkData2[0].temaTexter, beaconMajorValues: konstverkData2[0].beaconMajorValues, startBild: UIImage())
                
                print(konstverkTexter)
                print("KONSTTEXTER SPARADE")
                
                
                
                //                    if let url = URL(string: namn.bild) {
                //
                //                        print("kladdkaka2")
                //                        self.downloadImage(url: url)
                //
                //                            }
                
                
                
                
                
            } catch let jsonErr {
                print(jsonErr)
            }
            }.resume()
        //end of download session 2
        
        
        
    }
    
    
    
    
    
    //MARK: VIEW DID APPEAR__________!!!!!!!!!___________!!!!!!!!!_________!!!!!!!!__________!!!!!!!!!!
    
    override func viewDidAppear(_ animated: Bool) {
        
        repeat {
            print("hejdå")
        } while self.bildDictionary.count != self.konstName.count
        
        
        for urlen in self.bildUrl2 {
//            self.myRowKey = urlen
            self.myRowData = self.bildDictionary[urlen]!
            
            print("-----myrowkeyyyyyyyyyyeyeyeyyeyeyyeyeyeyyeyyyeeeeeeyeyeyeyeyyyyy-----------------------------------------")
            print(self.myRowData as Any)
            self.cellArray.append(self.myRowData)
            print("***IMAGE***\(self.cellArray)")
        }
        
//        let normalText3 = "Letar efter konstverk..."
//        let attribute4 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20)]
//        let normalString3 = NSMutableAttributedString(string: normalText3, attributes: attribute4)
//
//        showDetailLabel.text = normalText3
//        showDetailLabel.textColor = .gray
//
        
//        konstBild = (konstBilder?.konstBild)!
//        print("________________???????????????????_______________")
//        print(konstBild)
//
        
        //MARK: Beacon configuration
        
        beaconManager = KTKBeaconManager(delegate: self as? KTKBeaconManagerDelegate)
        
        //Set UUID string to the UUID of your beacons
        let myProximityUuid = UUID(uuidString: "1b65e4aa-df93-4be7-8054-0308c2587c13")
        
        let region = KTKBeaconRegion(proximityUUID: myProximityUuid!, identifier: "Beacon region 1")
        
        switch KTKBeaconManager.locationAuthorizationStatus() {
        case .notDetermined:
            beaconManager.requestLocationAlwaysAuthorization()
        case .denied, .restricted: break
        // No access to Location Services
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            
            //search for beacons in the region
            if KTKBeaconManager.isMonitoringAvailable() {
                
                beaconManager.startMonitoring(for: region)
                
                print("TACK FÖR ÅTGÅNG TILL PLATSTJÄNSTER 2")
                
            }
            beaconManager.startRangingBeacons(in: region)
            beaconManager.stopRangingBeacons(in: region)
            
        case .authorizedAlways:
            print("authorizedAlways")
            
            //search for beacons in the region
            if KTKBeaconManager.isMonitoringAvailable() {
                
                beaconManager.startMonitoring(for: region)
                
                print("TACK FÖR ÅTGÅNG TILL PLATSTJÄNSTER")
                
            }
            beaconManager.startRangingBeacons(in: region)
            beaconManager.stopRangingBeacons(in: region)
        }
        
//        showDetailButton.addTextSpacing(spacing: 2.5)
        
        
        print("slutat")
        
        
        
    }
    
    
    
    
    //MARK: VIEW DID LOAD__________!!!!!!!!!___________!!!!!!!!!_________!!!!!!!!__________!!!!!!!!!!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //download session 2
        //url which the "konstverk" objects are downloaded from
        let jsonUrlString = "https://konstapptest.eu-gb.mybluemix.net/konstverk"
        guard let url = URL(string: jsonUrlString) else
        { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            //perhaps check err
            //also perhaps check response status 200 OK
            
            guard let data = data else { return }
            //
            //
            do {
                //
                //decode konstverkData
                let konstverkData = try JSONDecoder().decode([KonstverkData4].self, from: data)
                print(konstverkData[0].namn)
                print(konstverkData[0].bild)
                //                print(konstverkData[0].texter)
                //                print(konstverkData[0].beaconMinor)
                //
                //
                //
                
                //add strings to arrays + download images
                for bild in konstverkData{
                    self.konstName.append(bild.namn)
                    self.beaconMinorValues.append(bild.beaconMinor)
                    self.beaconMajorValues.append(bild.beaconMajor)
                    self.konstnarName.append(bild.konstnar)
                    self.konstTexter.append(bild.texter)
                    self.bildUrl2.append(URL(string: bild.bild)!)
                    print("Found \(bild.bild)")
                    //                    self.bildDictionary[bild.bild] = bild.bild
                    //                    print(self.bildDictionary)
                    if let url = URL(string: bild.bild) {
                        print("kladdkaka!")
                        self.downloadImage(url: url)
                    }
                }
                
               
                //
                
                
            } catch let jsonErr {
                print(jsonErr)
                
            }
            
            
            }.resume()
        //end of download session 2
        
        //        beaconMinorValues = ["45", "16222", "28909"]
    
        // Do any additional setup after loading the view.
        
        button1.isSelected = true
        button1.backgroundColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:0.8)
        button2.backgroundColor = .white
        button3.backgroundColor = .white
        
        
        //set button image views content mode to aspect fit
        button1.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        button2.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        button3.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        button1.addBorder(side: UIButtonBorderSide.Top, color: UIColor.lightGray, width: 0.5)
        button2.addBorder(side: UIButtonBorderSide.Top, color: UIColor.lightGray, width: 0.5)
        button3.addBorder(side: UIButtonBorderSide.Top, color: UIColor.lightGray, width: 0.5)

        
    }
    
    
    
    
    //MARK: ACTIONS__________!!!!!!!!!___________!!!!!!!!!_________!!!!!!!!__________!!!!!!!!!!
    
//    @IBAction func showDetail(_ sender: Any) {
//
////       showDetailButton.backgroundColor = .lightGray
//    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    //MARK: FUNCTIONS__________!!!!!!!!!___________!!!!!!!!!_________!!!!!!!!__________!!!!!!!!!!
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    
    //function to download images for all the artworks from url
    func downloadImage(url: URL) {
        print("Started downloading")
        
        getDataFromUrl(url: url) {
            data, response, error in
            guard let data = data, error == nil else { return }
            
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Finished downloading")
            
            let imageData = UIImageJPEGRepresentation(UIImage(data: data)!, 1.0)
            
            
            
            //VAD HÄNDER HÄR????
            print("d-i-c-t-i-o-n-a-r-y-------------t-e-s-t---------!!!!!!!!_!_!_!_!_")
            self.bildDictionary[url] = UIImage(data: imageData as Data!)!
            print(self.bildDictionary)
            
            
            print("image downloaded and saved")
            
        }
    }
    
//    func downloadImage(url: URL) {
//        print("Started downloading")
//
//
//        getDataFromUrl(url: url) {
//            data, response, error in
//            guard let data = data, error == nil else { return }
//
//            print(response?.suggestedFilename ?? url.lastPathComponent)
//            print("Finished downloading")
//
//            let imageData = UIImageJPEGRepresentation(UIImage(data: data)!, 1.0)
//
//            self.beaconImage = [(UIImage(data: imageData as Data!)!)]
//
//            self.beaconBilden = self.beaconImage[0]
//
//            print(self.beaconBilden)
//            print("image downloaded and saved")
//
//            if self.beaconImage.count > 0 {
//                self.beaconKonstverk = Konstverk(title: self.beaconName, artistName: self.beaconArtist, photo: self.beaconBilden, about: self.beaconTexts, beaconMinor: self.beaconBEACON, beaconMajor: self.beaconBEACONBEACON)
//                print("BEACONKONSTVERK SAVED")
//            } else { print("ingen beaconImage")
//                return}
//        }
//    }
    
    
    
    
    
    
//    // MARK: - Navigation__________!!!!!!!!!___________!!!!!!!!!_________!!!!!!!!__________!!!!!!!!!!
//    
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        //        // Get the new view controller using segue.destinationViewController.
//        //        // Pass the selected object to the new view controller.
//        //
//        super.prepare(for: segue, sender: sender)
//
//        if segue.identifier == "konstvandringDetail" {
//            guard let ViewController = segue.destination as? ViewController else {
//                fatalError("Unexpected destination: \(segue.destination)")
//            }
//
//            guard konstverkTexter?.IBMKonstsamling != nil
//                else { print("Inga konstTexter")
//                    return
//            }
//            ViewController.konstverkTexter = konstverkTexter
//
//            guard validBeacons.count > 0
//                else {return}
//
//            guard beaconArray2 != ""
//                else {return}
//
//
//
//            //if beaconArray.count > 0 {
//
//            guard i >= 0
//                else {print("error: i är nil")
//                    return}
//            
//            print("OOOOOOOOOOOOOO")
//            print(i)
//            //                    print(beaconArray[i!])
//
//            beaconName = konstName[i]
//            beaconArtist = konstnarName[i]
//            //                    beaconImage = konstBild[i!]
//            //beaconBilden = (konstBilder?.konstBild[i])!
//            beaconBilden = cellArray[i]
//            beaconTexts = konstTexter[i]
//            beaconBEACON = beaconMinorValues[i]
//            //beaconBild = bildUrl[i]
//            beaconBEACONBEACON = beaconArray2
//
//            if beaconBilden != nil {
//                self.beaconKonstverk = Konstverk(title: self.beaconName, artistName: self.beaconArtist, photo: self.beaconBilden, about: self.beaconTexts, beaconMinor: self.beaconBEACON, beaconMajor: self.beaconBEACONBEACON)
//                print("BEACONKONSTVERK SAVED")
//            } else { print("ingen beaconImage")
//                return}
////
////            if let url = URL(string: beaconBild) {
////
////                print("kladdkaka2")
////                self.downloadImage(url: url)
////            }
//            print(beaconBEACON)
//
//
//                if beaconKonstverk?.beaconMinor != closestBeaconMinor {
//                    print("FEL KONSTVERK")
//                    return
//                } else {}
//
//
//
//            repeat {
//                print("WAIT")
//            }  while beaconKonstverk?.photo == nil
//
//            if beaconKonstverk?.photo !== nil {
//
//
//
//                ViewController.konstverket = beaconKonstverk
//                print("BEACONKONSTVERK : \(self.beaconKonstverk?.title, self.beaconKonstverk?.beaconMinor)")
//                print(ViewController.konstverket!)
//
//            } else {}
//
//            // } else {print("inga beacons i beaconArray")
//            //return
//            //}
//
//        }
//    }
    
    @IBAction func showText1(_ sender: UIButton) {
        displayString = verkText
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
    //...to the left
    @IBAction func nextText(_ sender: UISwipeGestureRecognizer) {
        if displayString == verkText {
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
            displayString = verkText
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
    
    //...to the right
    @IBAction func previousText(_ sender: UISwipeGestureRecognizer) {
        if displayString == verkText {
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
            displayString = verkText
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




//MARK: BEACONS__________!!!!!!!!!___________!!!!!!!!!_________!!!!!!!!__________!!!!!!!!!!

extension konstvandringViewController: KTKBeaconManagerDelegate {
    func beaconManager(_ manager: KTKBeaconManager, didChangeLocationAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            // When status changes to CLAuthorizationStatus.authorizedAlways
            // e.g. after calling beaconManager.requestLocationAlwaysAuthorization()
            // we can start region monitoring from here
        }
    }
    
    func beaconManager(_ manager: KTKBeaconManager, didStartMonitoringFor region: KTKBeaconRegion) {
        // Do something when monitoring for a particular
        // region is successfully initiated
    }
    
    func beaconManager(_ manager: KTKBeaconManager, monitoringDidFailFor region: KTKBeaconRegion?, withError error: Error?) {
        // Handle monitoring failing to start for your region
    }
    
    func beaconManager(_ manager: KTKBeaconManager, didEnter region: KTKBeaconRegion) {
        // Decide what to do when a user enters a range of your region; usually used
        // for triggering a local notification and/or starting a beacon ranging
        manager.startRangingBeacons(in: region)
        
    }
    
    func beaconManager(_ manager: KTKBeaconManager, didExitRegion region: KTKBeaconRegion) {
        // Decide what to do when a user exits a range of your region; usually used
        // for triggering a local notification and stoping a beacon ranging
        manager.stopRangingBeacons(in: region)
    }
    
    func beaconManager(_ manager: KTKBeaconManager, didDetermineState state: CLRegionState, for region: KTKBeaconRegion) {
        // Do something depending on a value of the state argument
    }
    
    func beaconManager(_ manager: KTKBeaconManager, didRangeBeacons beacons: [CLBeacon], in region: KTKBeaconRegion) {
        //        while beaconArray.count < 20 {
        
        //        print(beacons.first!)
        //        print(beacons)
        //
        //        for beacon in beacons {
        //
        //            print(beacon.proximity)
        //            print(beacon.minor.stringValue)
        
        
        
        //        for beacon in beacons {
        
        
        if beacons.count > 0 {
        
        if beacons.first!.rssi != 0 {
            
            validBeacons = beacons
            
        } else { for beacon in beacons {
            
            if beacon.rssi != 0 {
                
                validBeacons.append(beacon)
                beaconDistance.append(beacon.rssi)
                
            }
            }
            
            
            beaconDistance.sort { $0 < $1 }
            
            guard beaconDistance.first != nil
                else { print("invalid nearest beacon distance")
                    return
            }
            
            let beaconIndex = beaconDistance.first!
            
            for beacon2 in validBeacons {
                
                if beaconIndex == beacon2.rssi {
                    validBeacons2.append(beacon2)
                }
            }
            
            validBeacons = validBeacons2
            
        }
        
        //        }
        
        print("beacons in range: \(validBeacons)")
        
        beaconArray2 = validBeacons.first!.major.stringValue
        
        closestBeaconMinor = validBeacons.first!.minor.stringValue
        
        print(closestBeaconMinor)
        
        repeat {
            print("har inte hittat alla beaconMinorValues än")
        } while beaconMinorValues.count != konstName.count
        print(beaconMinorValues)
        
        if beaconMinorValues.contains(closestBeaconMinor) {
       i = beaconMinorValues.index(of: closestBeaconMinor)!
        
        
        print(i)
        
        print(konstName[i])
        
        
        print(konstBild)
            
            
            if cellArray.count == konstName.count {
        
                //Find index of "konstverket"'s beaconMajor in downloaded list of beacon majors
                let majorIndex = beaconMajorValues[i]
                let i4 = konstverkTexter?.beaconMajorValues.index(of: majorIndex)
                
                
                //find the "temaText" with the same index as beaconMajor in the downloaded array "temaTexter" = "temaText" for the right floor
                if i4 != nil {
                    temaText = (konstverkTexter?.temaTexter[i4!])!
                    print("vån \(temaText!)")
                } else {
                    temaText = "Ingen våning registrerad för konstverket"
                }
                
                titelLabel.text = konstName[i]
                konstnarLabel.text = konstnarName[i]
                verkText = konstTexter[i]
                //TESTA ATT SÄTTA IF STATEMENTS FÖR OM TEXTRUTAN VISAR RÄTT TEXT FÖR KNAPPEN SOM ÄR VALD OCH TESTA!!!
                print("TJOLAHOPP")
                if displayString != konstTexter[i]  && textView.text != konstTexter [i] && titelLabel.text == konstName[i] && button1.isSelected == true {
                    verkText = konstTexter[i]
                    displayString = verkText
                    textView.text = displayString
                } else if displayString != konstverkTexter?.temaTexter[i4!]  && textView.text != konstverkTexter?.temaTexter[i4!] && button2.isSelected == true {
                    temaText = konstverkTexter?.temaTexter[i4!]
                    displayString = temaText
                    textView.text = displayString
                    
                } else {}
                    
                
                
                verkText = konstTexter[i]
                IBMtext = konstverkTexter?.IBMKonstsamling
        
        //if imageView.image != konstBild[i] {
        placeholderView.isHidden = true
       // storStackView.isHidden = false
            scrollView.isHidden = false
            buttonStackView.isHidden = false
            
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.image = cellArray[i]
        //} else { return }
        
        //if bgImageView.image != konstBild[i] {
            bgImageView.image = cellArray[i]
       // } else { return }
        
//        if showDetailLabel.text != "Du befinner dig vid \(konstName[i])" {
//
//            let normalText = "Du befinner dig vid\n"
//        let attribute1 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18)]
//            let normalString = NSMutableAttributedString(string: normalText, attributes: attribute1)
//
//            let boldText = konstName[i]
//            let attribute2 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 27)]
//            let boldString = NSMutableAttributedString(string: boldText, attributes: attribute2)
//
//        let paragraphStyle = NSMutableParagraphStyle()
//
//        paragraphStyle.lineSpacing = 4
//
//        normalString.append(boldString)
//        normalString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, normalString.length))
//
////        showDetailLabel.textColor = .black
//
//        showDetailLabel.attributedText = normalString
//        showDetailLabel.textAlignment = NSTextAlignment.center
//            showDetailButton.isHidden = false
                
            
            } else {print("inte laddat ner alla bilder än \(cellArray)")
                return
            }
//
        } else {print("invalid beacon minor")
            return}
        
        } else {print("*NO BEACONS*")
//            showDetailButton.isHidden = true
           // storStackView.isHidden = true
            placeholderView.isHidden = false
            
            animationImageView.image = animation 
            
            
            let normalText2 = "Letar efter konstverk..."
            let attribute3 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20)]
            let normalString2 = NSMutableAttributedString(string: normalText2, attributes: attribute3)
            
            placeholderText.attributedText = normalString2
            placeholderText.textAlignment = NSTextAlignment.center
            placeholderText.textColor = .gray
            return
        }
        
        
        
        //        var beacons2 = beacons
        //
        //        for beacon in beacons2 {
        //
        //            if beacon.rssi == 0 {
        //
        //                let i2 = beacons2.index(of: beacon)
        //                beacons2.remove(at: i2!)
        //
        //            }
        //
        //        }
        //
        //        print("<#T##items: Any...##Any#>")
        
        
        //        while thisIsTheOne == false {
        //        for beacon in beacons {
        //
        //            if beacon.rssi != 0 {
        //
        //            print(beacon)
        //            print("Ranged beacon with Proximity UUID: \(beacon.proximityUUID), Major: \(beacon.major) and Minor: \(beacon.minor) from \(region.identifier) in \(beacon.proximity) proximity")
        //            print("HAAAAAAAAAAAAAAAAHOOOOOOOEEEEEEHJÄLP!")
        //            //add minor & major to arrays
        //            beaconArray.append(beacon.minor.stringValue)
        //            beaconen!.minor = beacon.minor.stringValue
        //            beaconArray2.append(beacon.major.stringValue)
        //            beaconen!.major = beacon.major.stringValue
        //            beaconDistance.append(beacon.rssi)
        //            beaconen!.distance = beacon.rssi
        //            print("DET HÄR ÄR EN BEACON \(beaconen?.minor, beaconen?.major, beaconen?.distance)")
        //            repeat {
        //                print("BEACONEN ÄR NIL")
        //            } while beaconen?.major == nil
        //            beaconens.append(beaconen!)
        //
        //            //print(beaconDistance)
        //            beaconDistance.sort { $0 < $1 }
        //            //print(beaconDistance)
        //
        //            if beaconDistance.count >= konstName.count {
        //
        //                for beaconsarna in beaconens {
        //
        //
        //                if beaconDistance.last == beaconsarna?.distance {
        //
        //                    print("THIS IS THE ONE!!! \(beaconsarna?.minor)")
        //
        //                    thisIsTheOne = true
        //                } else { print("this is not the one :(")}
        //
        //                }
        //            }
        //            }
        //        }
        //        }
        
        
        
        
        
        //            print("minor: \(beaconArray)")
        //            print("major: \(beaconArray2)")
        
        
        
    }
    
}

////Swipe animation
//extension UIView {
//    public func leftToRightAnimation(duration: TimeInterval = 0.5, completionDelegate: AnyObject? = nil) {
//        // Create a CATransition object
//        let leftToRightTransition = CATransition()
//
//        // Set its callback delegate to the completionDelegate that was provided
//        if let delegate: AnyObject = completionDelegate {
//            leftToRightTransition.delegate = delegate as? CAAnimationDelegate
//
//        }
//
//        leftToRightTransition.type = kCATransitionPush
//        leftToRightTransition.subtype = kCATransitionFromRight
//        leftToRightTransition.duration = duration
//        leftToRightTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        leftToRightTransition.fillMode = kCAFillModeRemoved
//
//        // Add the animation to the View's layernäm
//        self.layer.add(leftToRightTransition, forKey: "leftToRightTransition")
//
//    }
//
//}
//
//extension UIView {
//    public func rightToLeftAnimation(duration: TimeInterval = 0.5, completionDelegate: AnyObject? = nil) {
//        // Create a CATransition object
//        let rightToLeftTransition = CATransition()
//
//        // Set its callback delegate to the completionDelegate that was provided
//        if let delegate: AnyObject = completionDelegate {
//            rightToLeftTransition.delegate = delegate as? CAAnimationDelegate
//
//        }
//
//        rightToLeftTransition.type = kCATransitionPush
//        rightToLeftTransition.subtype = kCATransitionFromLeft
//        rightToLeftTransition.duration = duration
//        rightToLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        rightToLeftTransition.fillMode = kCAFillModeRemoved
//
//        // Add the animation to the View's layer
//        self.layer.add(rightToLeftTransition, forKey: "rightToLeftTransition")
//
//    }
//
//}
//
//
//extension UIButton {
//
//    public func addBorder(side: UIButtonBorderSide, color: UIColor, width: CGFloat) {
//        let border = CALayer()
//        border.backgroundColor = color.cgColor
//
//        switch side {
//        case .Top:
//            border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
//        case .Bottom:
//            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
//        case .Left:
//            border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
//        case .Right:
//            border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
//        }
//
//        self.layer.addSublayer(border)
//    }
//}


