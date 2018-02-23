//
//  ViewController.swift
//  KonstApp
//
//  Created by Kristin Rosen on 2018-02-22.
//  Copyright © 2018 Kristin Rosen and Fanny Erkhammar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var verkText: UIView!
    @IBOutlet weak var konstnarText: UIView!
    @IBOutlet weak var startText: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Hide the textfields
        verkText.isHidden = true
        konstnarText.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Actions
    
    //show verkText if "Om verket" button is pressed, and hide other text fields
    @IBAction func showVerkText(_ sender: UIButton) {
        verkText.isHidden = false
        konstnarText.isHidden = true
        startText.isHidden = true
    }
    
     //show konstnarText if "Om konstnären" button is pressed, and hide other text fields
    @IBAction func showKonstnarText(_ sender: UIButton) {
        konstnarText.isHidden = false
        verkText.isHidden = true
        startText.isHidden = true
    }
    
}

