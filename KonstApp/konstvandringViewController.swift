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

struct KonstverkData4: Decodable {
    let namn: String
    let konstnar: String
    let bild: String
    let texter: String
    let beaconMinor: String
}

struct KonstTextData: Decodable {
    let IBMkonstsamling: String
    let temaTexter: [String]
    let beaconMajorValues: [String]
    let startBild: String
}

var minorValue = String()

var i = Int()




var validBeacons = [CLBeacon]()

var validBeacons2 = [CLBeacon]()


var thisIsTheOne = Bool(false)

var konstverkTexter: KonstTexter?

var beaconen = Beacon(minor: "0", major: "0", distance: 0)

var beaconens = [Beacon(minor: "", major: "", distance: 1)]

var beaconDistance = [Int]()

var theOneAndOnly = Beacon(minor: "0", major: "0", distance: 0)

var closestBeaconMinor = String()

class konstvandringViewController: UIViewController, CLLocationManagerDelegate {
    
    
    var konstBilder = Images(konstBild: [UIImage()])
    
    var beaconKonstverk = Konstverk(title: "", artistName: "", photo: nil, about: "", beaconMinor: "", beaconMajor: "")
    
    var beaconManager: KTKBeaconManager!
    
    // minor och major hämtade från beacons
    //minor
    var beaconArray = [String]()
    
    //major
    var beaconArray2 = String()
    
    
    var konstName = [String]()
    
    var konstnarName = [String]()
    
    var bildUrl = [String]()
    
    var konstBild = [UIImage()]
    
    var konstTexter = [String]()
    
    var beaconMinorValues = [String]()
    
    var beaconMajorValues = [String]()
    
    @IBOutlet weak var showDetailButton: UIButton!
   
    @IBOutlet weak var showDetailLabel: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    
    var beaconImage = [UIImage]()
    var beaconUrl  = String()
    var beaconTexts = String()
    var beaconName = String()
    var beaconArtist = String()
    var beaconBEACON = String()
    var beaconBild = String()
    var beaconBEACONBEACON = String()
    
    var beaconBilden = UIImage()
    
    override func viewWillAppear(_ animated: Bool) {
        thisIsTheOne = false
        
        showDetailButton.backgroundColor = .white
        
        //stackView.setCustomSpacing(10, after: showDetailLabel)
        
        let verticalSpace = NSLayoutConstraint(item: showDetailLabel, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: showDetailLabel, attribute: .top, multiplier: 1, constant: 20)
        NSLayoutConstraint.activate([verticalSpace])
        
        showDetailLabel.textContainerInset = UIEdgeInsetsMake(20, 0, 0, 0)
        
        //nollställ beacon minor- & major-värden
        print("REMOVE BEACONS")
        validBeacons.removeAll()
        beaconArray.removeAll()
        beaconArray2.removeAll()
        print("BEACONS REMOVED")
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        konstBild = (konstBilder?.konstBild)!
        print("________________???????????????????_______________")
        print(konstBild)
        
        
        beaconManager = KTKBeaconManager(delegate: self as? KTKBeaconManagerDelegate)
        
        let myProximityUuid = UUID(uuidString: "1b65e4aa-df93-4be7-8054-0308c2587c13")
        let region = KTKBeaconRegion(proximityUUID: myProximityUuid!, identifier: "Beacon region 1")
        
        switch KTKBeaconManager.locationAuthorizationStatus() {
        case .notDetermined:
            beaconManager.requestLocationAlwaysAuthorization()
        case .denied, .restricted: break
        // No access to Location Services
        case .authorizedWhenInUse: break
            // For most iBeacon-based app this type of
        // permission is not adequate
        case .authorizedAlways:
            print("HEJHEJ")
            
            
            if KTKBeaconManager.isMonitoringAvailable() {
                
                beaconManager.startMonitoring(for: region)
                
                print("TACK FÖR ÅTGÅNG TILL PLATSTJÄNSTER")
                
            }
            beaconManager.startRangingBeacons(in: region)
            // We will use this later
            beaconManager.stopRangingBeacons(in: region)
        }
        
//        showDetailButton.addTextSpacing(spacing: 2.5)
        
        
        print("slutat")
        
        let jsonUrlString = "https://konstapptest.eu-gb.mybluemix.net/konstverk"
        guard let url = URL(string: jsonUrlString) else
        { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            //perhaps check err
            //also perhaps check response status 200 OK
            
            guard let data = data else { return }
            
            
            do {
                
                //decode data + print namn
                let konstverkData = try JSONDecoder().decode([KonstverkData4].self, from: data)
                print(konstverkData[0].namn)
                print(konstverkData[0].bild)
                print(konstverkData[0].texter)
                print(konstverkData[0].beaconMinor)
                
                
                
                for namn in konstverkData {
                    print("Found \(namn.namn)")
                    print("Found \(namn.konstnar)")
                    print("Found \(namn.texter)")
                    print("Found \(namn.beaconMinor)")
                    self.konstName.append(namn.namn)
                    self.konstnarName.append(namn.konstnar)
                    self.konstTexter.append(namn.texter)
                    self.beaconMinorValues.append(namn.beaconMinor)
                    self.bildUrl.append(namn.bild)
                    
                    
                    
                    //                    if let url = URL(string: namn.bild) {
                    //
                    //                        print("kladdkaka2")
                    //                        self.downloadImage(url: url)
                    //
                    //                            }
                }
                
                
                
                
            } catch let jsonErr {
                print(jsonErr)
            }
            }.resume()
        
        let jsonUrlString2 = "https://konstapptest.eu-gb.mybluemix.net/konstTexter"
        guard let url2 = URL(string: jsonUrlString2) else
        { return }
        
        URLSession.shared.dataTask(with: url2) { (data, response, err) in
            //perhaps check err
            //also perhaps check response status 200 OK
            
            guard let data = data else { return }
            
            
            do {
                
                //decode data + print namn
                let konstverkData2 = try JSONDecoder().decode([KonstTextData].self, from: data)
                print(konstverkData2[0].IBMkonstsamling)
                print(konstverkData2[0].temaTexter)
                print(konstverkData2[0].beaconMajorValues)
                
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
        
       
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showDetailButton.isHidden = true
        
       
        //        beaconMinorValues = ["45", "16222", "28909"]
    
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func showDetail(_ sender: Any) {
       
       showDetailButton.backgroundColor = .lightGray
    }
    
    @IBOutlet weak var showDetail: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
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
            
            let imageData = UIImageJPEGRepresentation(UIImage(data: data)!, 1.0)
            
            self.beaconImage = [(UIImage(data: imageData as Data!)!)]
            
            self.beaconBilden = self.beaconImage[0]
            
            print(self.beaconBilden)
            print("image downloaded and saved")
            
            if self.beaconImage.count > 0 {
                self.beaconKonstverk = Konstverk(title: self.beaconName, artistName: self.beaconArtist, photo: self.beaconBilden, about: self.beaconTexts, beaconMinor: self.beaconBEACON, beaconMajor: self.beaconBEACONBEACON)
                print("BEACONKONSTVERK SAVED")
            } else { print("ingen beaconImage")
                return}
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        // Get the new view controller using segue.destinationViewController.
        //        // Pass the selected object to the new view controller.
        //
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "konstvandringDetail" {
            guard let ViewController = segue.destination as? ViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard konstverkTexter?.IBMKonstsamling != nil
                else { print("Inga konstTexter")
                    return
            }
            ViewController.konstverkTexter = konstverkTexter
            
            guard validBeacons.count > 0
                else {return //lägg till "placeholder-konstverk"
            }
            
            guard beaconArray2.count > 0
                else {return}
            
            
            
            //if beaconArray.count > 0 {
            
            guard i >= 0
                else {print("error: i är nil")
                    return}
            
            print("OOOOOOOOOOOOOO")
            print(i)
            //                    print(beaconArray[i!])
            
            beaconName = konstName[i]
            beaconArtist = konstnarName[i]
            //                    beaconImage = konstBild[i!]
            beaconTexts = konstTexter[i]
            beaconBEACON = beaconMinorValues[i]
            beaconBild = bildUrl[i]
            beaconBEACONBEACON = beaconArray2
            
            if let url = URL(string: beaconBild) {
                
                print("kladdkaka2")
                self.downloadImage(url: url)
            }
            print(beaconBEACON)
            
            repeat {
                print("FEL KONSTVERK")
            } while beaconKonstverk?.beaconMinor != closestBeaconMinor
            
            repeat {
                print("WAIT")
            }  while beaconKonstverk?.photo == nil
            
            if beaconKonstverk?.photo !== nil {
                
                
               
                ViewController.konstverket = beaconKonstverk
                print("BEACONKONSTVERK : \(self.beaconKonstverk?.title, self.beaconKonstverk?.beaconMinor)")
                print(ViewController.konstverket!)
                
            }
            
            // } else {print("inga beacons i beaconArray")
            //return
            //}
            
        }
    }
    
    
}

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
        
        i = beaconMinorValues.index(of: closestBeaconMinor)!
        
        print(i)
        
        print(konstName[i])
        
        
        print(konstBild)
        
        repeat {
            print("beaconbilden är nil")
        } while beaconImage.count < 0
        
        if imageView.image != konstBild[i] {
        imageView.image = konstBild[i]
        } else { return }
        
        if bgImageView.image != konstBild[i] {
            bgImageView.image = konstBild[i]
        } else { return }
        
//        if showDetailLabel.text != "Du befinner dig vid \(konstName[i])" {
//
            let normalText = "Du befinner dig vid\n"
        let attribute1 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18)]
            let normalString = NSMutableAttributedString(string: normalText, attributes: attribute1)
        
            let boldText = konstName[i]
            let attribute2 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 27)]
            let boldString = NSMutableAttributedString(string: boldText, attributes: attribute2)
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = 4
        
        normalString.append(boldString)
        normalString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, normalString.length))
        
        showDetailLabel.attributedText = normalString
        showDetailLabel.textAlignment = NSTextAlignment.center
            showDetailButton.isHidden = false
//
//        } else {return}
        
        
        
        
        
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

