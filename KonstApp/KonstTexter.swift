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
    

    //initialization
    
    init?(IBMKonstsamling: String, temaTexter: [String]) {
        
        guard !IBMKonstsamling.isEmpty else {
            print("noText")
            return nil
        }
        
        self.IBMKonstsamling = IBMKonstsamling
        self.temaTexter = temaTexter
    }
    
}//end of class

