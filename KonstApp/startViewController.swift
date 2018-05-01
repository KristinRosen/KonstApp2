//
//  startViewController.swift
//  KonstApp
//
//  Created by Kristin Rosen on 2018-04-17.
//  Copyright © 2018 Kristin Rosen and Fanny Erkhammar. All rights reserved.
//

import UIKit
import KontaktSDK
import CoreLocation

class startViewController: UIViewController, CLLocationManagerDelegate {
    
    var manager = CLLocationManager()
    
    
    @IBOutlet weak var vandrButton: UIButton!
    @IBOutlet weak var allaButton: UIButton!
    
    var beaconImage = UIImage()
    var beaconUrl  = String()
    var beaconTexts = [String]()
    var beaconName = String()
    var beaconArtist = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("hsfyctutaulycutctctyc!!!!!!!!!!")
        
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        
            let uuid = NSUUID(uuidString: "1b65e4aa-df93-4be7-8054-0308c2587c13")
        let region = CLBeaconRegion(proximityUUID: uuid as! UUID, identifier: (uuid?.uuidString)!)
            manager.startMonitoring(for: region)
            manager.startRangingBeacons(in: region)
        print("hsfyctutaulycutctctyc!!!!!!!!!!")
        
        
        

        vandrButton.addTextSpacing(spacing: 2.5)
        allaButton.addTextSpacing(spacing: 2.5)
        
        manager.stopRangingBeacons(in: region)

        // Do any additional setup after loading the view.
        
        let jsonUrlString = "http://localhost:6002/beacon"
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

            let beaconKonstverk = Konstverk(title: beaconName, artistName: beaconArtist, photo: beaconImage, about: beaconTexts)

            ViewController.konstverket = beaconKonstverk
//
        }
    }
    
    // MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let region = region as? CLBeaconRegion {
            // region.major and region.minor will return nil
            manager.startRangingBeacons(in: region)
            print("Entered in region with UUID: \(region.proximityUUID) Major: \(String(describing: region.major)) Minor: \(String(describing: region.minor))")
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let region = region as? CLBeaconRegion {
            manager.stopRangingBeacons(in: region)
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

