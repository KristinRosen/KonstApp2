//
//  Urls.swift
//  KonstApp
//
//  Created by Fanny Erkhammar on 2018-05-17.
//  Copyright © 2018 Kristin Rosen and Fanny Erkhammar. All rights reserved.
//

import UIKit
import KontaktSDK


class Urls {
    
    var url: [URL]
    
    //MARK: Archiving Paths
    static let DocumentsDirectory2 = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL2 = DocumentsDirectory2.appendingPathComponent("urls")
    
    //MARK: Types
    
    struct PropertyKey {
        static let url = "url"
    }
    
    
    //initialization
    init?(url: [URL]) {
        
        guard !url.isEmpty else {
            print("noUrl")
            return nil
        }
        
        self.url = url
        
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(url, forKey: PropertyKey.url)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let url = aDecoder.decodeObject(forKey: PropertyKey.url) as? [URL] else {
            print("Unable to decode the url array for a Urls object.")
            return nil
        }

        
        // Must call designated initializer.
        self.init(url: url)
        
    }
    
}//end of class
