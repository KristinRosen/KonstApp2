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
    
    //text view
    @IBOutlet weak var text: UITextView!
    
    //image view
    @IBOutlet weak var imageView: UIImageView!
    
    //background image
    @IBOutlet weak var bgImageView: UIImageView!
    
    //label
    @IBOutlet weak var label: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Show the navigation bar in this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        //make font size adjust to accessibility settings
        text.font = UIFont.preferredFont(forTextStyle: .body)
        text.adjustsFontForContentSizeCategory = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //check that image from previous view controller is not nil
        guard konstverkTexterSa?.startBild != nil
            else {print("no startBild-image")
                return
        }
        
        //set image views to startBild
        imageView.image = konstverkTexterSa?.startBild
        bgImageView.image = konstverkTexterSa?.startBild
        
        //add margins to text views
        text.textContainerInset = UIEdgeInsetsMake(10, 10, 15, 10)
        label.textContainerInset = UIEdgeInsetsMake(16, 10, 5, 10)
        
        //set text and labels
        text.text = konstverkTexterSa!.IBMKonstsamling
        label.text = "IBM's konstsamling"
        self.title = "IBM's konstsamling"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
