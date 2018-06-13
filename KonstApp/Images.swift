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
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("images")
    
    //MARK: Types
    
    struct PropertyKey {
        static let konstBild = "konstBild"
    }
    
    
    //initialization
    init?(konstBild: [UIImage]) {
        
        guard !konstBild.isEmpty else {
            print("noImage")
            return nil
        }
        
        self.konstBild = konstBild
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(konstBild, forKey: PropertyKey.konstBild)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let konstBild = aDecoder.decodeObject(forKey: PropertyKey.konstBild) as? [UIImage] else {
            print("Unable to decode the image array for a Images object.")
            return nil
        }
        
        // Must call designated initializer.
        self.init(konstBild: konstBild)
        
    }
    
}//end of class

