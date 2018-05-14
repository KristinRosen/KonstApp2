//
//  beacon.swift
//  KonstApp
//
//  Created by Fanny Erkhammar on 2018-05-09.
//  Copyright © 2018 Kristin Rosen and Fanny Erkhammar. All rights reserved.
//

import Foundation
import KontaktSDK

import UIKit
import KontaktSDK

class Beacon {
    
    var minor: String
    
    var major: String
    
    var distance: Int
    
    
    //initialization
    
    init?(minor: String, major: String, distance: Int) {
        
        guard !minor.isEmpty else {
            print("noText")
            return nil
        }
        
        self.minor = minor
        self.major = major
        self.distance = distance
    
    }
    
}//end of class
