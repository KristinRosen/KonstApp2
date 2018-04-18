//
//  File.swift
//  KonstApp
//
//  Created by Kristin Rosen on 2018-03-09.
//  Copyright © 2018 Kristin Rosen and Fanny Erkhammar. All rights reserved.
//

import Foundation

struct Konstverk{
    let namn: String
    
}

enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

extension Konstverk {
    init?(json: [String: Any]) throws {
        guard let namn = json["namn"] as? String else {
            throw SerializationError.missing("namn")
        }
        
        self.namn = namn
    }
}



extension Konstverk {

    private let urlComponents: URLComponents // base URL components of the web service
    private let session: URLSession // shared session for interacting with the web service
    
    static func konstverk(matching query: String, completion: ([Konstverk]) -> Void) {
        var searchURLComponents = urlComponents
        searchURLComponents.path = "/konsrtverk"
        searchURLComponents.queryItems = [URLQueryItem(namn: "fiskmas", value: query)]
        let searchURL = searchURLComponents.url!
        
        session.dataTask(url: searchURL, completion: { (_, _, data, _)
            var konstverk: [Konstverk] = []
            
            if let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                for case let result in json["results"] {
                    if let konstverk = Konstverk(json: result) {
                        konstverk.append(konstverk)
                    }
                }
            }
            
            completion(konstverk)
        }).resume()
    }
}
