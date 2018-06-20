//
//  startViewController.swift
//  KonstApp
//
//  Created by Kristin Rosen on 2018-04-17.
//  Copyright © 2018 Kristin Rosen and Fanny Erkhammar. All rights reserved.
//

import UIKit
import KontaktSDK

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
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("----------------------------Välkommen  ---------------------------------")
        
        vandrButton.backgroundColor = UIColor(white: 1, alpha: 0.5)
        allaButton.backgroundColor = UIColor(white: 1, alpha: 0.81)
        ibmButton.backgroundColor = UIColor(white: 1, alpha: 0.95)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
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
                
            } catch let jsonErr {
                print(jsonErr)
            }
            }.resume()
        //end of download session 1
        
    }
    
    // Notification instructing user to change settings, send if access to location is denied
    func catchNotification(notification:Notification) -> Void {
        print("Catch notification")
        
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
            
            print("*******SEGUE*******")
            
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
            
            //make sure the text exists before continuing
            guard konstverkTexter2?.IBMKonstsamling != nil
                else { print("Inga konstTexter")
                    return
            }
            
            //pass the text "IBMs konstsamling" to the new view controller
            samlingViewController.konstverkTexterSa = konstverkTexter2
        }
        
    }
    
}//end of class

//extension to add spacing between letters for buttons
extension UIButton {
    func addTextSpacing(spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: (self.titleLabel?.text!)!)
        attributedString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: (self.titleLabel?.text!.characters.count)!))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}
