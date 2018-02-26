//
//  ViewController.swift
//  KonstApp
//
//  Created by Kristin Rosen on 2018-02-22.
//  Copyright © 2018 Kristin Rosen and Fanny Erkhammar. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    
    //MARK: Properties
    @IBOutlet weak var textView: UITextView!
    
    var displayString: String?
    var infoTexts = ["Konstverk", "Konstnär", "Koppling till IBM"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Actions
    @IBAction func showVerkText(_ sender: UISwipeGestureRecognizer) {
        if displayString == nil {
        displayString = infoTexts[0]
        textView.text = displayString
        } else if displayString == infoTexts[0] {
            displayString = infoTexts[1]
            textView.text = displayString
        } else if displayString == infoTexts[1] {
            displayString = infoTexts[2]
            textView.text = displayString
        } else {
            displayString = nil
            textView.text = displayString
        }
    }
}




