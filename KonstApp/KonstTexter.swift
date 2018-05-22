//
//  KonstTexter.swift
//  KonstApp
//
//  Created by Fanny Erkhammar on 2018-05-07.
//  Copyright © 2018 Kristin Rosen and Fanny Erkhammar. All rights reserved.
//

import UIKit
import KontaktSDK

class KonstTexter {
    
    var IBMKonstsamling: String
    
    var temaTexter: [String]
    
    var beaconMajorValues: [String]
    
    var startBild: UIImage?
    

    //initialization
    
    init?(IBMKonstsamling: String, temaTexter: [String], beaconMajorValues: [String], startBild: UIImage?) {
        
        guard !IBMKonstsamling.isEmpty else {
            print("noText")
            return nil
        }
        
        self.IBMKonstsamling = IBMKonstsamling
        self.temaTexter = temaTexter
        self.beaconMajorValues = beaconMajorValues
        self.startBild = startBild
    }
    
}//end of class

