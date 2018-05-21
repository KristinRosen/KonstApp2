//
//  samlingViewController.swift
//  KonstApp
//
//  Created by Kristin Rosen on 2018-04-26.
//  Copyright © 2018 Kristin Rosen and Fanny Erkhammar. All rights reserved.
//

import UIKit

class samlingViewController: UIViewController {
    
    var konstverkTexterSa: KonstTexter?
    
    var temaText: String?
    
    var IBMtext: String?

    @IBOutlet weak var text: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var label: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        // start activity indicator + hide image
//        imageView.isHidden = true
//        activityIndicator.hidesWhenStopped = true
//        activityIndicator.startAnimating()
        
        //add margins to text views
        text.textContainerInset = UIEdgeInsetsMake(10, 10, 15, 10)
        label.textContainerInset = UIEdgeInsetsMake(16, 10, 5, 10)
        
        
            self.imageView.image = #imageLiteral(resourceName: "bgImage")
//            self.activityIndicator.isHidden = true
//            self.imageView.isHidden = false
        
        
        
        
        
        
        
        
        
//        ----------------------thohoo
        
        
        
        
        
        
//        text.text = konstverkTexterSa!.IBMKonstsamling
        
        
        
        
        
        //hänä-------------------bye!!!!!!-------------------------------------------------
        
        
        
        
        
        
        
        
        label.text = "IBM's konstsamling"
        self.title = "IBM's konstsamling"
        
        let jsonUrlString3 = ""
        guard let url3 = URL(string: jsonUrlString3) else
        { return }
        
        URLSession.shared.dataTask(with: url3) { (data, response, err) in
            //perhaps check err
            //also perhaps check response status 200 OK
            
            guard let data = data else { return }
            
            
            do {
                
                //decode data + print namn
                let startData = try JSONDecoder().decode([StartData].self, from: data)
                print(startData[0].bild)
                
                if let url = URL(string: startData[0].bild) {
                    
                    print("kladdkaka2")
                    self.downloadImage2(url: url)
                    
                }
                
            } catch let jsonErr {
                print(jsonErr)
            }
            }.resume()
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage2(url: URL) {
        print("Started downloading")
        
        getDataFromUrl(url: url) {
            data, response, error in
            guard let data = data, error == nil else { return }
            
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Finished downloading startimage")
            
            let imageData = UIImageJPEGRepresentation(UIImage(data: data)!, 1.0)
            self.imageView.image = UIImage(data: imageData!)
            self.bgImage.image = UIImage(data: imageData!)
            
            print("startimage downloaded and saved")
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
