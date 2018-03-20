//
//  KonstverkTableViewController.swift
//  KonstApp
//
//  Created by Fanny Erkhammar on 2018-03-20.
//  Copyright © 2018 Kristin Rosen and Fanny Erkhammar. All rights reserved.
//

import UIKit

class KonstverkTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var bildUrl = String()
    
    var Konstverk = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jsonUrlString = "http://localhost:6001/konstverk"
        guard let url = URL(string: jsonUrlString) else
        { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            //perhaps check err
            //also perhaps check response status 200 OK
            
            guard let data = data else { return }
            
            
            do {
                
                //decode data + print namn
                let konstverkData = try JSONDecoder().decode([KonstverkData].self, from: data)
                print(konstverkData[0].namn)
                print(konstverkData[0].bild)
                print(konstverkData[0].texter)
                
                DispatchQueue.main.async {
                    self.previewLabel.text = konstverkData[0].namn
                    
                }
                self.bildUrl = konstverkData[0].bild
                
                
                
                
                
                
                //Set url for image
                
                if let url = URL(string: self.bildUrl) {
                    
                    //if image has previously been downloaded during the same session or previous session, load image from Userdefaults
                    //            if didDownload == true || checkIfDownloaded() == true {
                    //
                    //                let newData = UserDefaults.standard.object(forKey: "image.jpeg") as! NSData
                    //
                    //                self.imageView.image = UIImage(data: newData as Data)
                    //                self.bgImageView.image = UIImage(data: newData as Data)
                    //                self.activityIndicatorView.stopAnimating()
                    //                self.imageView.isHidden = false
                    //
                    //                print("image loaded from memory")
                    //
                    //            //Otherwise download and save image to UserDefaults
                    //            } else {
                    //
                    print("Hej")
                    //            }
                }
                
            } catch let jsonErr {
                print(jsonErr)
            }
            }.resume()



        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
