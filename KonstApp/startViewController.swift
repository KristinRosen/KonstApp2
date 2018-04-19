//
//  startViewController.swift
//  KonstApp
//
//  Created by Kristin Rosen on 2018-04-17.
//  Copyright © 2018 Kristin Rosen and Fanny Erkhammar. All rights reserved.
//

import UIKit
import KontaktSDK


class startViewController: UIViewController {

    @IBOutlet weak var vandrButton: UIButton!
    @IBOutlet weak var allaButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vandrButton.addTextSpacing(spacing: 2.5)
        allaButton.addTextSpacing(spacing: 2.5)

        // Do any additional setup after loading the view.
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



extension UIButton{
    func addTextSpacing(spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: (self.titleLabel?.text!)!)
        attributedString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: (self.titleLabel?.text!.characters.count)!))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}

