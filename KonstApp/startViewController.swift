//
//  startViewController.swift
//  KonstApp
//
//  Created by Kristin Rosen on 2018-04-17.
//  Copyright © 2018 Kristin Rosen and Fanny Erkhammar. All rights reserved.
//

import UIKit
import KontaktSDK


class startViewController: UIViewController {
    
    var beaconManager: KTKBeaconManager!

    @IBOutlet weak var vandrButton: UIButton!
    @IBOutlet weak var allaButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beaconManager = KTKBeaconManager(delegate: self as? KTKBeaconManagerDelegate)
        
        let myProximityUuid = UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")
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
            if KTKBeaconManager.isMonitoringAvailable() {
                beaconManager.startMonitoring(for: region)
            }
            // We will use this later
        }

        vandrButton.addTextSpacing(spacing: 2.5)
        allaButton.addTextSpacing(spacing: 2.5)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
//
//            let beaconKonstverkName = LÄGG TILL
//            print(beaconKonstverkName)
//            let beaconKonstnarName = LÄGG TILL
//            print(beaconKonstnarName)
//            let beaconKonstverkBild = LÄGG TILL
//            print(beaconKonstverkBild)
//            let beaconKonstverkTexter = LÄGG TILL
            let beaconKonstverk = Konstverk(title: "Fiskmas 2", artistName: "Kladdkaka", photo: #imageLiteral(resourceName: "kladdkaka"), about: ["fisk", "mas", "fismkas", "tjabbatjenahallå"])
//                beaconKonstverkName, artistName: beaconKonstnarName, photo: beaconKonstverkBild, about: beaconKonstverkTexter)
            ViewController.konstverket = beaconKonstverk
//
        }
    }


}

extension ViewController: KTKBeaconManagerDelegate {
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
        for beacon in beacons {
            print("Ranged beacon with Proximity UUID: \(beacon.proximityUUID), Major: \(beacon.major) and Minor: \(beacon.minor) from \(region.identifier) in \(beacon.proximity) proximity")
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

