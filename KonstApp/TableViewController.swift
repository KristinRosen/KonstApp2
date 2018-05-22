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


struct KonstverkData2: Decodable {
    let namn: String
    let konstnar: String
    let bild: String
    let texter: [String]
    let beaconMinor: String
    let beaconMajor: String
}

struct KonstverkData3 {
    var name: String
    var artist: String
    var image: UIImage
    var texts: [String]
}

struct KonstTextData2: Decodable {
    let IBMkonstsamling: String
    let temaTexter: [String]
    let beaconMajorValues: [String]
    let startBild: String
}

var konstverketTexter = KonstTexter(IBMKonstsamling: "", temaTexter: [""], beaconMajorValues: [""], startBild: UIImage())


class TableViewController: UITableViewController {
    
    @IBOutlet var konstTableView: UITableView!
    
    var konstName = [String]()
    
    var konstnarName = [String]()
    
    var bildUrl = [URL]()
    
    var konstBild = [UIImage()]
    
    var konstTexter = [[String]]()
    
    var MinorValues = [String]()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("T-J-E-N-A DETTA ÄR TABLEVIEEEEEEEEEEEEEEWNNN-!_!_!_!_!_!_!_!_")
        
        func configureTableView() {
            self.konstTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.konstTableView.frame = self.view.bounds
            self.konstTableView.dataSource = self
            self.view.addSubview(self.konstTableView)
        }
        
        
        konstTableView.delegate = self
        konstTableView.dataSource = self
        
        let jsonUrlString = "https://konstapptest.eu-gb.mybluemix.net/konstverk"
        guard let url = URL(string: jsonUrlString) else
        { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            //perhaps check err
            //also perhaps check response status 200 OK
            
            guard let data = data else { return }
            
            
            do {
                
                //decode data + print namn
                let konstverkData2 = try JSONDecoder().decode([KonstverkData2].self, from: data)
                print(konstverkData2[0].namn)
                print(konstverkData2[0].konstnar)
                print(konstverkData2[0].texter)
                print(konstverkData2[0].beaconMinor)
                print(konstverkData2[0].beaconMajor)
                print("Tjolahopp!!!!!")
                
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
                }
                
                print(self.konstName)
                print("UGAYGYAFYUFAYUFAYUA")
                print(self.MinorValues)
                print("________________________________________U-R-L--L-I-S-T-A___________________________________")
                print(self.bildUrl)
                
                //ta bort överflödig bild som skapas av mystisk anledning
                self.konstBild.remove(at: 0)
                print("superfluous image removed")
                
                for bild in konstverkData2{
                    print("Found \(bild.bild)")
                    //                    self.bildDictionary[bild.bild] = bild.bild
                    //                    print(self.bildDictionary)
                    if let url = URL(string: bild.bild) {
                        print("kladdkaka")
                        self.downloadImage(url: url)
                    }
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
                let konstTextData = try JSONDecoder().decode([KonstTextData2].self, from: data)
                print(konstTextData[0].IBMkonstsamling)
                print(konstTextData[0].temaTexter)
                print(konstTextData[0].beaconMajorValues)
                
                konstverketTexter = KonstTexter(IBMKonstsamling: konstTextData[0].IBMkonstsamling, temaTexter: konstTextData[0].temaTexter, beaconMajorValues: konstTextData[0].beaconMajorValues, startBild: UIImage())
                
                print(konstverketTexter!)
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
            
            
            
            
            print("d-i-c-t-i-o-n-a-r-y-------------t-e-s-t---------!!!!!!!!_!_!_!_!_")
            self.bildDictionary[url] = UIImage(data: imageData as Data!)!
            print(self.bildDictionary)
            
            
            
            
            self.konstBild.append(UIImage(data: imageData as Data!)!)
            
            print(self.konstBild)
            print("image downloaded and saved")
            
            DispatchQueue.main.async {
                self.konstTableView.reloadData()
            }
        }
    }
    // MARK: - Table view data source
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if bildDictionary.count == konstName.count {
            return konstName.count
        } else {print("AAAAASAVENJAAABABABISHIMAMA"); return 0}
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        for urlen in bildUrl {
            self.myRowKey = urlen
            self.myRowData = self.bildDictionary[myRowKey]!
            
            print("-----myrowkeyyyyyyyyyyeyeyeyyeyeyyeyeyeyyeyyyeeeeeeyeyeyeyeyyyyy-----------------------------------------")
            print(myRowKey)
            print(myRowData as Any)
            cellArray.append(myRowData)
            print(cellArray)
        }
        
        cell.tabelLable.text = self.konstName[indexPath.row]
        cell.tabelLable2.text = self.konstnarName[indexPath.row]
        //        cell.tableImageView.image = self.konstBild[indexPath.row] as UIImage
        cell.tableImageView.image = cellArray[indexPath.row] as UIImage
        
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        
        if segue.identifier == "ShowDetail" {
            
            guard let ViewController = segue.destination as? ViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedCell = sender as? TableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
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
            
            
            
            
        }
        
        
    }
    
    
}//end of class
