//
//  startViewController.swift
//  KonstApp
//
//  Created by Kristin Rosen on 2018-04-17.
//  Copyright © 2018 Kristin Rosen and Fanny Erkhammar. All rights reserved.
//

import UIKit
import KontaktSDK

var isRanging = Bool()
var beaconMinor = CLBeaconMinorValue(1)

class startViewController: UIViewController, CLLocationManagerDelegate {
    
    var beaconManager: KTKBeaconManager!

    var beaconArray = [NSNumber]()
    
    @IBOutlet weak var vandrButton: UIButton!
    @IBOutlet weak var allaButton: UIButton!
    @IBOutlet weak var ibmButton: UIButton!
    
    var beaconImage = UIImage()
    var beaconUrl  = String()
    var beaconTexts = [String]()
    var beaconName = String()
    var beaconArtist = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

        vandrButton.addTextSpacing(spacing: 2.5)
        allaButton.addTextSpacing(spacing: 2.5)
        ibmButton.addTextSpacing(spacing: 2.5)

        // Do any additional setup after loading the view.
        
        
        print("slutat")
        
        let jsonUrlString = "http://localhost:6001/konstverk"
        guard let url = URL(string: jsonUrlString) else
        { return }
        
       URLSession.shared.dataTask(with: url) { (data, response, err) in
            //perhaps check err
            //also perhaps check response status 200 OK
            
            guard let data = data else { return }
            
            
            do {
                
                //decode data + print namn
                let konstverkData = try JSONDecoder().decode([KonstverkData2].self, from: data)
                print(konstverkData[0].namn)
                print(konstverkData[0].bild)
                print(konstverkData[0].texter)
                
                DispatchQueue.main.async {
                    self.beaconName = konstverkData[0].namn
                    self.beaconArtist = konstverkData[0].konstnar
                    self.beaconTexts = konstverkData[0].texter
                    self.beaconUrl = konstverkData[0].bild
                    
                    if let url = URL(string: self.beaconUrl) {
                        
                        print("kladdkaka2")
                        self.downloadImage(url: url)
                        
                    }
                    
                }
               
            } catch let jsonErr {
                print(jsonErr)
        }
        }.resume()

}

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
            
            self.beaconImage = UIImage(data: imageData as Data!)!
            
            print(self.beaconImage)
            print("image downloaded and saved")
            
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//
        super.prepare(for: segue, sender: sender)

        if segue.identifier == "konstvandring" {
            guard let ViewController = segue.destination as? ViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }

            let beaconKonstverk = Konstverk(title: beaconName, artistName: beaconArtist, photo: beaconImage, about: beaconTexts, beaconMinor: beaconMinor)

            ViewController.konstverket = beaconKonstverk
//
        }
    }

}

extension startViewController: KTKBeaconManagerDelegate {
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
        while beaconArray.count < 3 {
        for beacon in beacons {
            print("Ranged beacon with Proximity UUID: \(beacon.proximityUUID), Major: \(beacon.major) and Minor: \(beacon.minor) from \(region.identifier) in \(beacon.proximity) proximity")
            print("HAAAAAAAAAAAAAAAAHOOOOOOOEEEEEEHJÄLP!")
            beaconArray.append(beacon.minor)
            }
      print(beaconArray)
        }
        
        
    }
}

extension UIButton{
    func addTextSpacing(spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: (self.titleLabel?.text!)!)
        attributedString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: (self.titleLabel?.text!.characters.count)!))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}

