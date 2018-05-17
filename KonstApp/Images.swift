//
//  Images.swift
//  KonstApp
//
//  Created by Fanny Erkhammar on 2018-05-17.
//  Copyright © 2018 Kristin Rosen and Fanny Erkhammar. All rights reserved.
//

import UIKit
import KontaktSDK


class Images {
    
    var konstBild: [UIImage]
    
    
    
    
    //initialization
    
    init?(konstBild: [UIImage]) {
        
        guard !konstBild.isEmpty else {
            print("noImage")
            return nil
        }
        
        self.konstBild = konstBild
    }
    
}//end of class

