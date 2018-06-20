//
//  TableViewController.swift
//  KonstApp
//
//  Created by Kristin Rosen on 2018-03-21.
//  Copyright © 2018 Kristin Rosen and Fanny Erkhammar. All rights reserved.
//

import UIKit
import os.log
import KontaktSDK


//structure used for downloading Json object "konstverk" from url
struct KonstverkData2: Decodable {
    let namn: String
    let konstnar: String
    let bild: String
    let texter: String
    let beaconMinor: String
    let beaconMajor: String
}

//structure used for downloading Json object "konstTexter" from url
struct KonstTextData2: Decodable {
    let IBMkonstsamling: String
    let temaTexter: [String]
    let beaconMajorValues: [String]
    let startBild: String
}

//konstTexter class object for passing information to the next view
var konstverketTexter = KonstTexter(IBMKonstsamling: "", temaTexter: [""], beaconMajorValues: [""], startBild: UIImage())

//int describing number of rows in tableView (default value can be any number over 0)
var i2 = 5

var theCell = UITableViewCell()

//class for table view of all artworks
class TableViewController: UITableViewController {
    
    
    //MARK: Properties
    
    //table view
    @IBOutlet var konstTableView: UITableView!
    
    
    //Variables
    
    //placeholders
    
    var placeholderBilder = Array(repeating: #imageLiteral(resourceName: "defaultPicture"), count: i2)
    var placeholderText1 = Array(repeating: "", count: i2)
    var placeholderText2 = Array(repeating: "", count: i2)
    
    //array of all titles
    var konstName = [String]()
    
    //array of all artist names
    var konstnarName = [String]()
    
    //array of all image urls
    var bildUrl = [URL]()
    
    //array of all artworks' texts
    var konstTexter = [String]()
    
    //array of all artworks' corresponding beacon minor values
    var MinorValues = [String]()
    
    //array of all artworks' corresponding beacon major values (artworks/beacons on the same floor has the same value here)
    var MajorValues = [String]()
    
    
    var bildDictionary = [URL: UIImage]()
    
    var keyList:[URL] {
        get{
            return [URL](self.bildDictionary.keys)
        }
    }
    
    var cellArray = [UIImage]()
    
    var myRowKey: URL!
    var myRowData = UIImage()
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Show the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        theCell.isHighlighted = false
        theCell.isSelected = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configure table view
        func configureTableView() {
            self.konstTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.konstTableView.frame = self.view.bounds
            self.konstTableView.dataSource = self
            self.view.addSubview(self.konstTableView)
        }
        
        konstTableView.delegate = self
        konstTableView.dataSource = self
        
        //MARK: Download from url
        
        //download session 1
        let jsonUrlString = "https://konst.eu-gb.mybluemix.net/konstverk"
        guard let url = URL(string: jsonUrlString) else
        { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            guard let data = data else { return }
            
            do {
                
                //decode konstverkData + print "namn"
                let konstverkData2 = try JSONDecoder().decode([KonstverkData2].self, from: data)
                print(konstverkData2[0].namn)
                print(konstverkData2[0].konstnar)
                print(konstverkData2[0].texter)
                print(konstverkData2[0].beaconMinor)
                print(konstverkData2[0].beaconMajor)
                
                //add strings to arrays
                for namn in konstverkData2{
                    print("Found \(namn.namn)")
                    print("Found \(namn.konstnar)")
                    print("Found \(namn.texter)")
                    print("Found \(namn.beaconMinor)")
                    print("Found \(namn.beaconMajor)")
                    self.konstName.append(namn.namn)
                    self.konstnarName.append(namn.konstnar)
                    self.konstTexter.append(namn.texter)
                    self.MinorValues.append(namn.beaconMinor)
                    self.MajorValues.append(namn.beaconMajor)
                    self.bildUrl.append(URL(string: namn.bild)!)
                    i2 = self.konstName.count
                }
                
                print(self.konstName)
                print(self.MinorValues)
                print(self.bildUrl)
                
                //download images
                for bild in konstverkData2{
                    print("Found \(bild.bild)")
                    if let url = URL(string: bild.bild) {
                        self.downloadImage(url: url)
                    }
                }
            } catch let jsonErr {
                print(jsonErr)
            }
            }.resume()
        
        //end of download session 1
        
        //download session 2
        let jsonUrlString2 = "https://konst.eu-gb.mybluemix.net/konstTexter"
        guard let url2 = URL(string: jsonUrlString2) else
        { return }
        
        URLSession.shared.dataTask(with: url2) { (data, response, err) in

            guard let data = data else { return }
            
            do {
                
                //decode konstTextData + print "namn"
                let konstTextData = try JSONDecoder().decode([KonstTextData2].self, from: data)
                print(konstTextData[0].IBMkonstsamling)
                print(konstTextData[0].temaTexter)
                print(konstTextData[0].beaconMajorValues)
                
                //add values to KonstTexter class object "konstverkTexter"
                konstverketTexter = KonstTexter(IBMKonstsamling: konstTextData[0].IBMkonstsamling, temaTexter: konstTextData[0].temaTexter, beaconMajorValues: konstTextData[0].beaconMajorValues, startBild: UIImage())
                
                print("konstTexter downloaded")
                
            } catch let jsonErr {
                print(jsonErr)
            }
            }.resume()
        
        //end of download session 2
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: FUNCTIONS
    
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
            
            //reload the tableView data
            DispatchQueue.main.async {
                self.konstTableView.reloadData()
            }
        }
    }
    
    
    // MARK: Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return konstName.count
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        //set placeholder images with activity indicators while the data is being downloaded
        while self.bildDictionary.count != self.konstName.count {
            
            cell.tabelLable.text = placeholderText1[indexPath.row]
            cell.tabelLable2.text = placeholderText2[indexPath.row]
            cell.tableImageView.image = placeholderBilder[indexPath.row] as UIImage
            tableView.estimatedRowHeight = 100
            tableView.rowHeight = UITableViewAutomaticDimension
            
            cell.activityIndicator.color = UIColor.white
            cell.activityIndicator.hidesWhenStopped = true
            cell.activityIndicator.startAnimating()
            
            return cell
        }
        
        //get the images from bildDictionary by their url and add to cellArray in the right order
        for urlen in bildUrl {
            self.myRowData = self.bildDictionary[urlen]!
            cellArray.append(myRowData)
        }
        
        //add the approperiate data to the table view cell
        cell.tabelLable.text = self.konstName[indexPath.row]
        cell.tabelLable2.text = self.konstnarName[indexPath.row]
        cell.tableImageView.image = cellArray[indexPath.row] as UIImage
        
        //stop the activity indicator
        cell.activityIndicator.stopAnimating()
        
        //make font size adjust to accessibility settings
        cell.tabelLable.font = UIFont.preferredFont(forTextStyle: .body)
        cell.tabelLable.adjustsFontForContentSizeCategory = true
        
        cell.tabelLable2.font = UIFont.preferredFont(forTextStyle: .body)
        cell.tabelLable2.adjustsFontForContentSizeCategory = true
        
        //enable automatic dimention
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        return cell
    }
    
    
    // MARK: Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        theCell = (sender as? TableViewCell)!
        theCell.isSelected = false
        theCell.setHighlighted(true, animated: true)
        
        if segue.identifier == "ShowDetail" {
            
        
            guard let ViewController = segue.destination as? ViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedCell = sender as? TableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            selectedCell.isSelected = false
            
            
            guard let indexPath = tableView.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            //prevent segue from happening if the image has not loaded yet (function declared below)
            shouldPerformSegue(withIdentifier: "ShowDetail", sender: TableViewController.self)
            
            //add the data from the selected table view cell to a "Konstverk" class object in order to pass the data to the next viewController
            let selectedKonstverkName = konstName[indexPath.row]
            print(selectedKonstverkName)
            let selectedKonstnarName = konstnarName[indexPath.row]
            print(selectedKonstnarName)
            let selectedKonstverkBild = cellArray[indexPath.row]
            print(selectedKonstverkBild)
            let selectedKonstverkTexter = konstTexter[indexPath.row]
            let selectedKonstverkBeaconMinor = MinorValues[indexPath.row]
            let selectedKonstverkBeaconMajor = MajorValues[indexPath.row]
            
            let selectedKonstverk = Konstverk(title: selectedKonstverkName, artistName: selectedKonstnarName, photo: selectedKonstverkBild, about: selectedKonstverkTexter, beaconMinor: selectedKonstverkBeaconMinor, beaconMajor: selectedKonstverkBeaconMajor)
            
            ViewController.konstverket = selectedKonstverk
            ViewController.konstverkTexter = konstverketTexter
            
        } else {}
        
    }
    
    //function to prevent segues from happening if a condition is not fullfilled (add conditions by adding on to the if-statement below, separating the conditions with ||)
    //Segue will happen if this function returns true
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if cellArray.count < konstName.count  {
            theCell.isSelected = false
            print("!segue will not happen")
            return false
            
        } else { return true }
        
    }
    
}//end of class


