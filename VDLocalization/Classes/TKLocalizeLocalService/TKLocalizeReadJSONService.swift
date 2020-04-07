//
//  TKLocalizeReadJSONService.swift
//  TKLocalization
//
//  Created by Vu Doan on 9/25/19.
//  Copyright © 2019 Vu Doan. All rights reserved.
//

import Foundation

public class TKLocalizeReadJSONService {
    static func readJSONFromFile(fileName: String) -> [String : [String: String]]? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = jsonObj as? [String: Any] {
                    var languages: [String : [String: String]] = [:]
                    if let vi = object["vi"] as? [String : String] {
                        languages["vi"] = vi
                    }
                    if let en = object["en"] as? [String : String] {
                        languages["en"] = en
                    }
                    return languages
                } else {
                    return nil
                }
            } catch _ {
                return nil
            }
        } else {
            return nil
        }
    }
}
