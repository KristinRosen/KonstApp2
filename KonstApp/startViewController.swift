//
//  startViewController.swift
//  KonstApp
//
//  Created by Kristin Rosen on 2018-04-17.
//  Copyright © 2018 Kristin Rosen and Fanny Erkhammar. All rights reserved.
//

import UIKit
import KontaktSDK

//var isRanging = Bool()
////var beaconMinor = CLBeaconMinorValue(1)

////structure used to decode json objects "konstverk"
//struct KonstverkData3: Decodable {
//    let namn: String
//    let konstnar: String
//    let bild: String
//    let texter: String
//    let beaconMinor: String
//}

//structure used to decode json object "konstTexter"
struct KonstTextData3: Decodable {
    let IBMkonstsamling: String
    let temaTexter: [String]
    let beaconMajorValues: [String]
    let startBild: String
}

//konstTexter class object for passing information to the next view
var konstverkTexter2: KonstTexter?

//Images class object for passing downloaded images to the next view
var imagess = Images(konstBild: [UIImage()])




//var minorValue = String()

//var i = Int()

//var validBeacons = [CLBeacon]()

//var validBeacons2 = [CLBeacon]()

//var thisIsTheOne = Bool(false)

//var startBild = [UIImage()]

//var beaconen = Beacon(minor: "0", major: "0", distance: 0)

//var beaconens = [Beacon(minor: "", major: "", distance: 1)]

//var beaconDistance = [Int]()

//var theOneAndOnly = Beacon(minor: "0", major: "0", distance: 0)

//var closestBeaconMinor = String()

    class startViewController: UIViewController/*, CLLocationManagerDelegate*/ {

 var beaconManager: KTKBeaconManager!
 let myNotification = Notification.Name(rawValue:"MyNotification")
        
    //MARK: Properties
        
    //OUTLETS
        
    @IBOutlet weak var vandrButton: UIButton!
    @IBOutlet weak var allaButton: UIButton!
    @IBOutlet weak var ibmButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

        
    //VARIABLES
        
//    //array of all downloaded titles
//    var konstName = [String]()
//
//    //array of all downloaded image urls
//    var bildUrl = [URL]()
//
//        var bildDictionary = [URL: UIImage]()
//
//        var keyList:[URL] {
//            get{
//                return [URL](self.bildDictionary.keys)
//            }
//        }
//
//    var cellArray = [UIImage]()
//
//    var myRowKey: URL!
//    var myRowData = UIImage()
        

//var beaconBilden = UIImage()
        
//var beaconImage = [UIImage]()
        
//    var beaconKonstverk = Konstverk(title: "", artistName: "", photo: nil, about: //[""], beaconMinor: "", beaconMajor: "")
        
//    var beaconManager: KTKBeaconManager!
        
// minor och major hämtade från beacons
      //minor
//    var beaconArray = [String]()
        
//    //major
//    var beaconArray2 = String()
        
//    var konstnarName = [String]()
        
//    var konstTexter = [[String]]()
        
//    var beaconMinorValues = [String]()
        
        
//    var beaconUrl  = String()
//    var beaconTexts = [String]()
//    var beaconName = String()
//    var beaconArtist = String()
//    var beaconBEACON = String()
//    var beaconBild = String()
//    var beaconBEACONBEACON = String()
//
   
//
//    override func viewWillAppear(_ animated: Bool) {
//        thisIsTheOne = false
//
//    //nollställ beacon minor- & major-värden
//    print("REMOVE BEACONS")
//    validBeacons.removeAll()
//    beaconArray.removeAll()
//    beaconArray2.removeAll()
//    print("BEACONS REMOVED")
//
//    }
        
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("----------------------------Välkommen  ---------------------------------")
        
        vandrButton.backgroundColor = UIColor(white: 1, alpha: 0.5)
        allaButton.backgroundColor = UIColor(white: 1, alpha: 0.81)
        ibmButton.backgroundColor = UIColor(white: 1, alpha: 0.95)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
//        print("will empty arrays")
////
//        //empty all arrays
//        bildDictionary.removeAll()
//        konstName.removeAll()
//        bildUrl.removeAll()
//        cellArray.removeAll()
////
//        print("arrays emptied")
        
        
        //MARK: Download from url
        
        //download session 1
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
                let konstTextData2 = try JSONDecoder().decode([KonstTextData3].self, from: data)
                print(konstTextData2[0].IBMkonstsamling)
                print(konstTextData2[0].temaTexter)
                print(konstTextData2[0].beaconMajorValues)
                
                //set konstTexter class object "konstverkTexter2" texts
                konstverkTexter2 = KonstTexter(IBMKonstsamling: konstTextData2[0].IBMkonstsamling, temaTexter: konstTextData2[0].temaTexter, beaconMajorValues: konstTextData2[0].beaconMajorValues, startBild: nil)
                
                //download the image "startBild"
                if let url2 = URL(string: konstTextData2[0].startBild) {
                    
                    self.downloadImage2(url: url2)
                }
                
                
                print(konstverkTexter2)
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
        //end of download session 1
        
//        //download session 2
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
//            //
//            //
//            do {
//                //
//                //decode konstverkData
//                let konstverkData = try JSONDecoder().decode([KonstverkData3].self, from: data)
//                print(konstverkData[0].namn)
//                print(konstverkData[0].bild)
//                //                print(konstverkData[0].texter)
//                //                print(konstverkData[0].beaconMinor)
//                //
//                //
//                //
//
//                //add strings to arrays + download images
//                for bild in konstverkData{
//                    self.konstName.append(bild.namn)
//                    self.bildUrl.append(URL(string: bild.bild)!)
//                    print("Found \(bild.bild)")
//                    //                    self.bildDictionary[bild.bild] = bild.bild
//                    //                    print(self.bildDictionary)
//                    if let url = URL(string: bild.bild) {
//                        print("kladdkaka")
//                        self.downloadImage(url: url)
//                    }
//                }
//                //
//
//
//            } catch let jsonErr {
//                print(jsonErr)
//
//            }
//
//
//            }.resume()
//        //end of download session 2
        
        

        
//        beaconManager = KTKBeaconManager(delegate: self as? KTKBeaconManagerDelegate)
//
//        let myProximityUuid = UUID(uuidString: "1b65e4aa-df93-4be7-8054-0308c2587c13")
//        let region = KTKBeaconRegion(proximityUUID: myProximityUuid!, identifier: "Beacon region 1")
//
//        switch KTKBeaconManager.locationAuthorizationStatus() {
//        case .notDetermined:
//            beaconManager.requestLocationAlwaysAuthorization()
//        case .denied, .restricted: break
//        // No access to Location Services
//        case .authorizedWhenInUse: break
//            // For most iBeacon-based app this type of
//        // permission is not adequate
//        case .authorizedAlways:
//            print("HEJHEJ")
//
//
//            if KTKBeaconManager.isMonitoringAvailable() {
//
//                beaconManager.startMonitoring(for: region)
//
//                print("TACK FÖR ÅTGÅNG TILL PLATSTJÄNSTER")
//
//            }
//            beaconManager.startRangingBeacons(in: region)
//            // We will use this later
//            beaconManager.stopRangingBeacons(in: region)
//        }
        
        

//        print("slutat")
//
    
    }

//        override func viewDidAppear(_ animated: Bool) {
//
//
//        }

        // Notification instructing user to change settings, send if access to location is denied
        func catchNotification(notification:Notification) -> Void {
            print("Catch notification")
            
//            guard let userInfo = notification.userInfo,
//                let message  = userInfo["message"] as? String,
//                let date     = userInfo["date"]    as? Date else {
//                    print("No userInfo found in notification")
//                    return
//            }
            
            let alert = UIAlertController(title: "Appen behöver tillgång till platstjänster",
                                          message:"Ändra inställningar för appen under integritetsskydd för kunna använda konstvandringsläget",
                preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Viewdidloaddd------------------------------------------------")
        
        //setup for when the view loads
        imageView.isHidden = true
        activityIndicator.color = UIColor.white
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
      
        //add text spacing to the buttons
        vandrButton.addTextSpacing(spacing: 2.5)
        allaButton.addTextSpacing(spacing: 2.5)
        ibmButton.addTextSpacing(spacing: 2.5)
        
        let nc = NotificationCenter.default
        nc.addObserver(forName:myNotification, object:nil, queue:nil, using:catchNotification)
        
//        beaconMinorValues = ["45", "16222", "28909"]
        
        // Do any additional setup after loading the view.
        
        
        beaconManager = KTKBeaconManager(delegate: self as? KTKBeaconManagerDelegate)
        
        // Check access to location. Ask for access if the app has not asked before, send notification if it is denied.
        switch KTKBeaconManager.locationAuthorizationStatus() {
        case .notDetermined:
            beaconManager.requestLocationAlwaysAuthorization()
        case .denied, .restricted:
        print("access to location denied")
        let nc = NotificationCenter.default
        nc.post(name:myNotification,
                object: nil,
                userInfo:[:])
        case .authorizedWhenInUse:
            print("location authorizedWhenInUse")
        case .authorizedAlways:
            print("location authorizedAlways")
            
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

        
    //function to get data from url, used in downloadImage function
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }

//        //function to download images for all the artworks from url
//        func downloadImage(url: URL) {
//            print("Started downloading")
//
//            getDataFromUrl(url: url) {
//                data, response, error in
//                guard let data = data, error == nil else { return }
//
//                print(response?.suggestedFilename ?? url.lastPathComponent)
//                print("Finished downloading")
//
//                let imageData = UIImageJPEGRepresentation(UIImage(data: data)!, 1.0)
//
//
//
//                //VAD HÄNDER HÄR????
//                print("d-i-c-t-i-o-n-a-r-y-------------t-e-s-t---------!!!!!!!!_!_!_!_!_")
//                self.bildDictionary[url] = UIImage(data: imageData as Data!)!
//                print(self.bildDictionary)
//
//
//                print("image downloaded and saved")
//
//            }
//        }
        
        //function to download the front page image from url
        func downloadImage2(url: URL) {
            print("Started downloading2")
            
            getDataFromUrl(url: url) {
                data, response, error in
                guard let data = data, error == nil else { return }
                
                print(response?.suggestedFilename ?? url.lastPathComponent)
                print("Finished downloading startimage")
                
                let imageData = UIImageJPEGRepresentation(UIImage(data: data)!, 1.0)
                
                //set image view and background to downloaded "startBild"
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: imageData!)
                    self.bgImage.image = UIImage(data: imageData!)
                    konstverkTexter2?.startBild = UIImage(data: imageData!)
                    self.activityIndicator.stopAnimating()
                    self.imageView.isHidden = false
                    //                startBild.append(UIImage(data: imageData!)!)
                }
                
                
                print("startimage downloaded and saved")
                
            }
        }
        

//
        // MARK: - Navigation
        
        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            //
            //
            //
            super.prepare(for: segue, sender: sender)
            
            //if the "konstvandring" button has been selected
            if segue.identifier == "konstvandring" {
                
                vandrButton.backgroundColor = UIColor(white: 0.7, alpha:0.5)
                
                guard let konstvandringViewController = segue.destination as? konstvandringViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                //                //prevent segue from happen if all the images have not been saved to the dictionary (function declared below)
                //                shouldPerformSegue(withIdentifier: "konstvandring", sender: startViewController.self)
                print("*******SEGUE*******")
                
                
                //wait until all bildUrls have been downloaded
                
                //                repeat {
                //                    print("inga bildUrl")
                //                } while bildUrl.count < 1
                //
                //                repeat {
                //                    print("WAIT2")
                //                } while konstName.count != bildUrl.count
                
                //wait until alla the images have been added to the "bildDictionary"
                //                repeat {
                //                    print("WAIT3")
                //                    loadingOverlay.isHidden = false
                //                    activityindicator2.isHidden = false
                //                } while bildDictionary.count != bildUrl.count
                
                //                for urlen in self.bildUrl {
                //                    self.myRowKey = urlen
                //                    self.myRowData = self.bildDictionary[self.myRowKey]!
                //
                //                    print("-----myrowkeyyyyyyyyyyeyeyeyyeyeyyeyeyeyyeyyyeeeeeeyeyeyeyeyyyyy-----------------------------------------")
                //                    print(self.myRowKey)
                //                    print(self.myRowData as Any)
                //                    self.cellArray.append(self.myRowData)
                //                    print(self.cellArray)
                //                }
                
                //                repeat {
                //                    print("alla konstbilder inte nedladdade än")
                //                    loadingOverlay.isHidden = false
                //                    activityindicator2.isHidden = false
                //                } while cellArray.count != konstName.count
                
                //                if self.cellArray.count > 0 {
                
                
                //imagess = Images(konstBild: self.cellArray)
                //                } else {print("inga bilder1")
                //                    return}
                
                //make sure there are images before continuing
                //                guard imagess!.konstBild.count > 0
                //                    else {
                //                        print("inga bilder2")
                //                        return
                //                }
                
                // Pass the downloaded images for all artworks to the new view controller
                //                konstvandringViewController.konstBilder = imagess
                
                
                //            guard konstverkTexter?.IBMKonstsamling != nil
                //                else { print("Inga konstTexter")
                //                    return
                //            }
                //                ViewController.konstverkTexter = konstverkTexter
                //
                //            guard validBeacons.count > 0
                //                else {return //lägg till "placeholder-konstverk"
                //            }
                //
                //            guard beaconArray2.count > 0
                //                else {return}
                //
                //            minorValue = closestBeaconMinor
                //            i = beaconMinorValues.index(of: minorValue)!
                //
                //        //if beaconArray.count > 0 {
                //
                //            guard i >= 0
                //                else {print("error: i är nil")
                //                    return}
                //
                //                    print("OOOOOOOOOOOOOO")
                //            print(i)
                ////                    print(beaconArray[i!])
                //
                //            beaconName = konstName[i]
                //            beaconArtist = konstnarName[i]
                ////                    beaconImage = konstBild[i!]
                //            beaconTexts = konstTexter[i]
                //            beaconBEACON = beaconMinorValues[i]
                //            beaconBild = bildUrl[i]
                //                    beaconBEACONBEACON = beaconArray2
                //
                //                if let url = URL(string: beaconBild) {
                //
                //                    print("kladdkaka2")
                //                    self.downloadImage(url: url)
                //                }
                //                print(beaconBEACON)
                //
                //            repeat {
                //                print("FEL KONSTVERK")
                //            } while beaconKonstverk?.beaconMinor != closestBeaconMinor
                //
                //                repeat {
                //        print("WAIT")
                //                }  while beaconKonstverk?.photo == nil
                //
                //                if beaconKonstverk?.photo !== nil {
                //
                //
                //
                //                    ViewController.konstverket = beaconKonstverk
                //                    print("BEACONKONSTVERK : \(self.beaconKonstverk?.title, self.beaconKonstverk?.beaconMinor)")
                //                    print(ViewController.konstverket!)
                //
                //                }
                
                // } else {print("inga beacons i beaconArray")
                //return
                //}
                //if the "Alla konstverk" button has been selected
            } else if segue.identifier == "allaKonstverk" {
                
                allaButton.backgroundColor = UIColor(white: 0.7, alpha:0.81)
                
                guard let TableViewController = segue.destination as? TableViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                //if the "IBMs konstsamling" button has been selected
            } else if segue.identifier == "ibmKonstsamling" && konstverkTexter2?.startBild != nil {
                
                ibmButton.backgroundColor = UIColor(white: 0.7, alpha:0.95)
                
                guard let samlingViewController = segue.destination as? samlingViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                //                //prevent segue from happening if the image has not loaded yet (function declared below)
                //                shouldPerformSegue(withIdentifier: "ibmKonstsamling", sender: startViewController.self)
                
                
                //make sure the text exists before continuing
                guard konstverkTexter2?.IBMKonstsamling != nil
                    else { print("Inga konstTexter")
                        return
                }
                
                //pass the text "IBMs konstsamling" to the new view controller
                samlingViewController.konstverkTexterSa = konstverkTexter2
            }
            
            
            
            //        } else if segue.identifier == "ibmKonstsamling" && konstverkTexter2?.startBild == nil {
            //
            //        }
            
        }

//        //function to prevent segues from happening if a condition is not fullfilled (add conditions by adding on to the if-statement below, separating the conditions with ||)
//        //Segue will happen if this function returns true
//        override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//            
//            if konstverkTexter2?.startBild == nil || bildDictionary.count != bildUrl.count {
//                print("------------------------________!segue will not happen!_______-----------------------")
//                return false
//                
//                //            } else if  imagess?.konstBild.count != konstName.count {
//                //                return false
//            } else { return true }
//            
//        }
    
}//end of class


//extension startViewController: KTKBeaconManagerDelegate {
//    func beaconManager(_ manager: KTKBeaconManager, didChangeLocationAuthorizationStatus status: CLAuthorizationStatus) {
//        if status == .authorizedAlways {
//            // When status changes to CLAuthorizationStatus.authorizedAlways
//            // e.g. after calling beaconManager.requestLocationAlwaysAuthorization()
//            // we can start region monitoring from here
//        }
//    }

//    func beaconManager(_ manager: KTKBeaconManager, didStartMonitoringFor region: KTKBeaconRegion) {
//        // Do something when monitoring for a particular
//        // region is successfully initiated
//    }

//    func beaconManager(_ manager: KTKBeaconManager, monitoringDidFailFor region: KTKBeaconRegion?, withError error: Error?) {
//        // Handle monitoring failing to start for your region
//    }

//    func beaconManager(_ manager: KTKBeaconManager, didEnter region: KTKBeaconRegion) {
//        // Decide what to do when a user enters a range of your region; usually used
//        // for triggering a local notification and/or starting a beacon ranging
//        manager.startRangingBeacons(in: region)

//    }

//    func beaconManager(_ manager: KTKBeaconManager, didExitRegion region: KTKBeaconRegion) {
//        // Decide what to do when a user exits a range of your region; usually used
//        // for triggering a local notification and stoping a beacon ranging
//        manager.stopRangingBeacons(in: region)
//    }

//    func beaconManager(_ manager: KTKBeaconManager, didDetermineState state: CLRegionState, for region: KTKBeaconRegion) {
//        // Do something depending on a value of the state argument
//    }

//    func beaconManager(_ manager: KTKBeaconManager, didRangeBeacons beacons: [CLBeacon], in region: KTKBeaconRegion) {
////        while beaconArray.count < 20 {

////        print(beacons.first!)
////        print(beacons)

////        for beacon in beacons {

////            print(beacon.proximity)
////            print(beacon.minor.stringValue)



////        for beacon in beacons {

//            if beacons.first!.rssi != 0 {

//                validBeacons = beacons

//            } else { for beacon in beacons {

//                if beacon.rssi != 0 {

//                    validBeacons.append(beacon)
//                    beaconDistance.append(beacon.rssi)

//                        }
//                    }

//                beaconDistance.sort { $0 < $1 }

//                let beaconIndex = beaconDistance.first!

//                for beacon2 in validBeacons {

//                    if beaconIndex == beacon2.rssi {
//                        validBeacons2.append(beacon2)
//                    }
//                }

//                validBeacons = validBeacons2

//                }

////        }

//        print("beacons in range: \(validBeacons)")

//        beaconArray2 = validBeacons.first!.major.stringValue

//        closestBeaconMinor = validBeacons.first!.minor.stringValue

////        var beacons2 = beacons

////        for beacon in beacons2 {

////            if beacon.rssi == 0 {

////                let i2 = beacons2.index(of: beacon)
////                beacons2.remove(at: i2!)

////            }

////        }

////        print("<#T##items: Any...##Any#>")


////        while thisIsTheOne == false {
////        for beacon in beacons {

////            if beacon.rssi != 0 {

////            print(beacon)
////            print("Ranged beacon with Proximity UUID: \(beacon.proximityUUID), Major: \(beacon.major) and Minor: \(beacon.minor) from \(region.identifier) in \(beacon.proximity) proximity")
////            print("HAAAAAAAAAAAAAAAAHOOOOOOOEEEEEEHJÄLP!")
////            //add minor & major to arrays
////            beaconArray.append(beacon.minor.stringValue)
////            beaconen!.minor = beacon.minor.stringValue
////            beaconArray2.append(beacon.major.stringValue)
////            beaconen!.major = beacon.major.stringValue
////            beaconDistance.append(beacon.rssi)
////            beaconen!.distance = beacon.rssi
////            print("DET HÄR ÄR EN BEACON \(beaconen?.minor, beaconen?.major, beaconen?.distance)")
////            repeat {
////                print("BEACONEN ÄR NIL")
////            } while beaconen?.major == nil
////            beaconens.append(beaconen!)

////            //print(beaconDistance)
////            beaconDistance.sort { $0 < $1 }
////            //print(beaconDistance)

////            if beaconDistance.count >= konstName.count {

////                for beaconsarna in beaconens {


////                if beaconDistance.last == beaconsarna?.distance {

////                    print("THIS IS THE ONE!!! \(beaconsarna?.minor)")

////                    thisIsTheOne = true
////                } else { print("this is not the one :(")}

////                }
////            }
////            }
////        }
////        }


////            print("minor: \(beaconArray)")
////            print("major: \(beaconArray2)")

//    }
//}


//extension to add spacing between letters for buttons
extension UIButton {
    func addTextSpacing(spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: (self.titleLabel?.text!)!)
        attributedString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: (self.titleLabel?.text!.characters.count)!))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}


