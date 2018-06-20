//
//  konstvandringViewController.swift
//  KonstApp
//
//  Created by Fanny Erkhammar on 2018-05-16.
//  Copyright © 2018 Kristin Rosen and Fanny Erkhammar. All rights reserved.
//

import UIKit
import KontaktSDK
import CoreBluetooth

var isRanging = Bool()

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

//KonstTexter class object used to pass data from previous view
var konstverkTexter: KonstTexter?

//array containing rssi values of found beacons
var beaconDistance = [Int]()

//minor value of the closest beacon
var closestBeaconMinor = String()

//the text which is currently displayed in the textView
var displayString: String?

//text about the currently displayed artwork
var verkText: String?

//the "temaText" for the currently displayed artwork
var temaText: String?

//text about the art collection (same text for all artworks)
var IBMtext: String?


class konstvandringViewController: UIViewController, CLLocationManagerDelegate {
    
    //MARK: Properties
    
    //OUTLETS
    
    @IBOutlet weak var stackView: UIStackView!
    
    //lable displaying closest artwork name
    @IBOutlet weak var titelLabel: UITextView!
    @IBOutlet weak var konstnarLabel: UITextView!
    
    @IBOutlet weak var textView: UITextView!
    
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
    
    let myNotification2 = Notification.Name(rawValue:"MyNotification2")
    
    var centralManager: CBCentralManager!
    
    //placeholder animation
    let animation = UIImage.animatedImage(with: [#imageLiteral(resourceName: "signal1"), #imageLiteral(resourceName: "signal2"), #imageLiteral(resourceName: "signal3"), #imageLiteral(resourceName: "signal4")], duration: 1.5)
    
    //Konstverk class object used to pass "konstverk" object to the next view
    var beaconKonstverk = Konstverk(title: "", artistName: "", photo: nil, about: "", beaconMinor: "", beaconMajor: "")
    
    //beacon manager
    var beaconManager: KTKBeaconManager!
    
    //major value of closest beacon
    var closestBeaconMajor = String()
    
    //array of downloaded titles
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
    
    //Dictionary where the images will be added with their url as key
    var bildDictionary = [URL: UIImage]()
    
    //All the images in the right order
    var cellArray = [UIImage]()
    
    //Image fetched from bildDictionary
    var myRowData = UIImage()
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Show the navigation bar in this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        //hide stack view and show placeholder when view appears
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
        
        //display the animation while searching for beacons
        animationImageView.image = animation
        
        //add margins to text views
        textView.textContainerInset = UIEdgeInsetsMake(10, 10, 15, 10)
        
        titelLabel.textContainerInset = UIEdgeInsetsMake(16, 10, 0, 10)
        
        konstnarLabel.textContainerInset = UIEdgeInsetsMake(0, 10, 5, 10)
        
        //reset beacon minor & major values
        print("REMOVE BEACONS")
        validBeacons.removeAll()
        cellArray.removeAll()
        print("BEACONS REMOVED")
        
        
        //MARK: Download from url
        
        //download session 1
        //url which the "konstTexter" object is downloaded from
        let jsonUrlString2 = "https://konst.eu-gb.mybluemix.net/konstTexter"
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
                print("text download complete")
                
            } catch let jsonErr {
                print(jsonErr)
            }
            }.resume()
        //end of download session 2
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        //wait until all the images have been added to bildDictionary
        repeat {
            print("loading bildDictionary")
        } while self.bildDictionary.count != self.konstName.count
        
        //get the images from bildDictionary and add to cellArray in the same order as the urls
        for urlen in self.bildUrl2 {
            self.myRowData = self.bildDictionary[urlen]!
            self.cellArray.append(self.myRowData)
            
        }
        
        //MARK: Beacon configuration
        
        beaconManager = KTKBeaconManager(delegate: self as? KTKBeaconManagerDelegate)
        
        //Set UUID string to the UUID of your beacons
        let myProximityUuid = UUID(uuidString: "1b65e4aa-df93-4be7-8054-0308c2587c13")
        
        let region = KTKBeaconRegion(proximityUUID: myProximityUuid!, identifier: "Beacon region 1")
        
        //check location authorization status and start looking for beacons if access is allowed
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
            }
            
            beaconManager.startRangingBeacons(in: region)
            beaconManager.stopRangingBeacons(in: region)
            
        case .authorizedAlways:
            print("authorizedAlways")
            
            //search for beacons in the region
            if KTKBeaconManager.isMonitoringAvailable() {
                
                beaconManager.startMonitoring(for: region)
            }
            
            beaconManager.startRangingBeacons(in: region)
            beaconManager.stopRangingBeacons(in: region)
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        //needed for notification
        let nc = NotificationCenter.default
        nc.addObserver(forName:myNotification2, object:nil, queue:nil, using:catchNotification)
        
        //download session 2
        //url which the "konstverk" objects are downloaded from
        let jsonUrlString = "https://konst.eu-gb.mybluemix.net/konstverk"
        guard let url = URL(string: jsonUrlString) else
        { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            guard let data = data else { return }
            
            do {
                
                //decode konstverkData
                let konstverkData = try JSONDecoder().decode([KonstverkData4].self, from: data)
                print(konstverkData[0].namn)
                print(konstverkData[0].bild)
                
                //add strings to arrays + download images
                for bild in konstverkData{
                    self.konstName.append(bild.namn)
                    self.beaconMinorValues.append(bild.beaconMinor)
                    self.beaconMajorValues.append(bild.beaconMajor)
                    self.konstnarName.append(bild.konstnar)
                    self.konstTexter.append(bild.texter)
                    self.bildUrl2.append(URL(string: bild.bild)!)
                    print("Found \(bild.bild)")
                    if let url = URL(string: bild.bild) {
                        self.downloadImage(url: url)
                    }
                }
                
            } catch let jsonErr {
                print(jsonErr)
            }
            
            }.resume()
        //end of download session 2
        
        //make the first button selected when the view appears
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: FUNCTIONS
    
    //notification to send if Bluetooth is turned off
    func catchNotification(notification:Notification) -> Void {
        print("Catch notification")
        
        let alert = UIAlertController(title: "Appen behöver Bluetooth",
                                      message:"Slå på Bluetooth för kunna använda konstvandringsläget",
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //function that gets data from the urls
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    //function to download images from url
    func downloadImage(url: URL) {
        print("Started downloading")
        
        getDataFromUrl(url: url) {
            data, response, error in
            guard let data = data, error == nil else { return }
            
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Finished downloading")
            
            let imageData = UIImageJPEGRepresentation(UIImage(data: data)!, 1.0)
            
            //add the image data to bildDictionary
            self.bildDictionary[url] = UIImage(data: imageData as Data!)!
            print("image added to dictionary")
            
        }
    }
    
    //MARK: ACTIONS
    
    //Change text + select corresponding buttons when tapping buttons (for all possible cases)
    
    //Button 1 is tapped
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
    
    //Button 2
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
    
    //Button 3
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

//MARK: Beacons

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
        
        //following code will be executed every time the app has recieved signals from a beacon
        
        if beacons.count > 0 {
            
            //sort out the beacons with rssi = 0 (those beacons are out of range)
            if beacons.first!.rssi != 0 {
                
                validBeacons = beacons
                
            } else { for beacon in beacons {
                
                if beacon.rssi != 0 {
                    
                    validBeacons.append(beacon)
                    beaconDistance.append(beacon.rssi)
                    
                }
                
                }
                
                //sort the beacons by distance by sorting their rssi values by size
                beaconDistance.sort { $0 < $1 }
                
                guard beaconDistance.first != nil
                    else { print("invalid nearest beacon distance")
                        return
                }
                
                //get the closest beacons rssi value
                let closestBeaconRssi = beaconDistance.first!
                
                //add the valid beacon(s) with the closest rssi to a new array
                for beacon2 in validBeacons {
                    
                    if closestBeaconRssi == beacon2.rssi {
                        validBeacons2.append(beacon2)
                    }
                }
                
                //make validBeacons the closest beacon(s)
                validBeacons = validBeacons2
                
            }
            
            
            print("beacons in range: \(validBeacons)")
            
            //set closestBeaconMajor to the closest beacons major value
            closestBeaconMajor = validBeacons.first!.major.stringValue
            
            //set closestBeaconMinor to the closest beacons minor value
            closestBeaconMinor = validBeacons.first!.minor.stringValue
            
            print(closestBeaconMinor)
            
            repeat {
                print("looking for beacon minor values")
            } while beaconMinorValues.count != konstName.count
            print(beaconMinorValues)
            
            if beaconMinorValues.contains(closestBeaconMinor) {
                //get the index of the closest beacons minor value in beaconMinorValues
                i = beaconMinorValues.index(of: closestBeaconMinor)!
                
                print(i)
                
                //print closest konstverk title
                print(konstName[i])
                
                if cellArray.count == konstName.count {
                    
                    //Find index of "konstverket"'s beaconMajor in downloaded list of beacon majors
                    let majorIndex = beaconMajorValues[i]
                    let i4 = konstverkTexter?.beaconMajorValues.index(of: majorIndex)
                    
                    
                    //find the "temaText" with the same index as beaconMajor in the downloaded array "temaTexter" = "temaText" for the right floor
                    if i4 != nil {
                        temaText = (konstverkTexter?.temaTexter[i4!])!
                    } else {
                        temaText = "Ingen våning registrerad för konstverket"
                    }
                    
                    //set textviews texts to the approperiate texts
                    titelLabel.text = konstName[i]
                    konstnarLabel.text = konstnarName[i]
                    verkText = konstTexter[i]
                    
                    //update the first text if the beacon changes and button1 is selected
                    if displayString != konstTexter[i]  && textView.text != konstTexter [i] && titelLabel.text == konstName[i] && button1.isSelected == true {
                        verkText = konstTexter[i]
                        displayString = verkText
                        textView.text = displayString
                        
                        //update the second text if the beacon changes and button2 is selected
                    } else if displayString != konstverkTexter?.temaTexter[i4!]  && textView.text != konstverkTexter?.temaTexter[i4!] && button2.isSelected == true {
                        temaText = konstverkTexter?.temaTexter[i4!]
                        displayString = temaText
                        textView.text = displayString
                        
                    } else {}
                    
                    verkText = konstTexter[i]
                    IBMtext = konstverkTexter?.IBMKonstsamling
                    
                    //hide the placeholder views
                    placeholderView.isHidden = true
                    scrollView.isHidden = false
                    buttonStackView.isHidden = false
                    
                    imageView.contentMode = UIViewContentMode.scaleAspectFill
                    
                    //set image views to the right image
                    imageView.image = cellArray[i]
                    
                    bgImageView.image = cellArray[i]
                    
                } else {print("cellArray not done yet \(cellArray)")
                    return
                }
                
            } else {print("invalid beacon minor")
                return}
            
        } else {print("NO BEACONS")
            
            //show placeholder view if no beacons are found
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
        
    }
    
}

//Function that checks if Bluetooth is on, sends notification saying it needs to be turned on if it is turned off
extension konstvandringViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
            
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
            let nc = NotificationCenter.default
            nc.post(name:myNotification2,
                    object: nil,
                    userInfo:[:])
        case .poweredOn:
            print("central.state is .poweredOn")
        }
    }
    
    
}
