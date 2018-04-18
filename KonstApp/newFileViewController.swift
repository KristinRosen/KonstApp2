//
//  newFileViewController.swift
//  KonstApp
//
//  Created by Kristin Rosen on 2018-03-20.
//  Copyright © 2018 Kristin Rosen and Fanny Erkhammar. All rights reserved.
//

import UIKit

class newFileViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jsonUrlString = "http://localhost:6002/konstverk"
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
                    self.textViewLabel.text = konstverkData[0].namn
                    self.infoTexts = konstverkData[0].texter
                    self.displayString = self.infoTexts[0]
                    self.textView.text = self.displayString
                }
                self.bildUrl = konstverkData[0].bild
                
                
            } catch let jsonErr {
                print(jsonErr)
            }
            }.resume()
        
        

        // Do any additional setup after loading the view.
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
            DispatchQueue.main.async() {
                
                let dataREP = UIImageJPEGRepresentation(UIImage(data: data)!, 1.0)
                
                UserDefaults.standard.set(dataREP, forKey: "image.jpeg")
                
                let newData = UserDefaults.standard.object(forKey: "image.jpeg") as! NSData
                
                self.imageView.image = UIImage(data: newData as Data)
                self.bgImageView.image = UIImage(data: newData as Data)
                self.activityIndicatorView.stopAnimating()
                self.imageView.isHidden = false
                
                self.didDownload = true
                
                print("image downloaded and saved")
                
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
