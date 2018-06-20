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
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var label: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("_______________WE WELCOME YOU TO THE KONSTSAMLINGsA_______________")
        print(konstverkTexterSa?.startBild)
        
        //Show the navigation bar in this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        //make font size adjust to accessibility settings
        text.font = UIFont.preferredFont(forTextStyle: .body)
        text.adjustsFontForContentSizeCategory = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        guard konstverkTexterSa?.startBild != nil
            else {print("ingen start-bild")
                return
        }
        
        imageView.image = konstverkTexterSa?.startBild
        bgImageView.image = konstverkTexterSa?.startBild
        
        //add margins to text views
        text.textContainerInset = UIEdgeInsetsMake(10, 10, 15, 10)
        label.textContainerInset = UIEdgeInsetsMake(16, 10, 5, 10)
        
        text.text = konstverkTexterSa!.IBMKonstsamling
        label.text = "IBM's konstsamling"
        self.title = "IBM's konstsamling"
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
    
}
