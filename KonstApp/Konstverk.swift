//
//  Konstverk.swift
//  KonstApp
//
//  Created by Fanny Erkhammar on 2018-04-03.
//  Copyright © 2018 Kristin Rosen and Fanny Erkhammar. All rights reserved.
//

import UIKit

class Konstverk {
    
    
    var title: String
    
    var photo: UIImage
    
    var about: [String]
    
    
    //initialization
    
    init?(title: String, photo: UIImage?, about: [String]?) {
        
        guard !title.isEmpty else {
            print("noName")
            return nil
        }
        
        self.title = title
        self.photo = photo!
        self.about = about!
    }
    
}//end of class
