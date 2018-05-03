//
//  Konstverk.swift
//  KonstApp
//
//  Created by Fanny Erkhammar on 2018-04-03.
//  Copyright © 2018 Kristin Rosen and Fanny Erkhammar. All rights reserved.
//

import UIKit
import KontaktSDK


class Konstverk {
    
    
    var title: String
    
    var artistName: String
    
    var photo: UIImage
    
    var about: [String]
    
    var beaconMinor: UInt16
    
    
    //initialization
    
    init?(title: String, artistName: String, photo: UIImage?, about: [String]?, beaconMinor: UInt16) {
        
        guard !title.isEmpty else {
            print("noName")
            return nil
        }
        
        self.title = title
        self.artistName = artistName
        self.photo = photo!
        self.about = about!
        self.beaconMinor = beaconMinor
    }
    
}//end of class
