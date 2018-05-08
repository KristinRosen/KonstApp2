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
        
        text.text = konstverkTexterSa!.IBMKonstsamling
        label.text = "IBM's konstsamling"
        self.title = "IBM's konstsamling"
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
