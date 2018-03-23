//
//  TableViewController.swift
//  KonstApp
//
//  Created by Kristin Rosen on 2018-03-21.
//  Copyright © 2018 Kristin Rosen and Fanny Erkhammar. All rights reserved.
//

import UIKit

struct KonstverkData2: Decodable {
    let namn: String
    let bild: String
}

class TableViewController: UITableViewController {

    @IBOutlet var konstTableView: UITableView!
    
    var konstName = [String]()
    
    var bildUrl = String()
    
    var konstBild = [UIImage()]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func configureTableView() {
            self.konstTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.konstTableView.frame = self.view.bounds
            self.konstTableView.dataSource = self
            self.view.addSubview(self.konstTableView)
        }

        
        konstTableView.delegate = self
        konstTableView.dataSource = self
        
        let jsonUrlString = "http://localhost:6002/konstverk"
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
                print("Tjolahopp!!!!!")
                
                self.konstName = [konstverkData2[0].namn]
                print(self.konstName)
                
                self.bildUrl = konstverkData2[0].bild
                
                if let url = URL(string: self.bildUrl) {
                    
                    print("kladdkaka")
                    self.downloadImage(url: url)
                    
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
                
            self.konstBild = [UIImage(data: imageData as Data!)!]
                
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
        return konstName.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell

        cell.tabelLable.text = konstName[indexPath.row]
        cell.tableImageView.image = konstBild[indexPath.row] as UIImage

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
