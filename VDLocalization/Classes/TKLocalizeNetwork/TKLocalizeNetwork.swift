//
//  TKLocalizeNetwork.swift
//  TKLocalization
//
//  Created by Vu Doan on 9/25/19.
//  Copyright © 2019 Vu Doan. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class TKLocalizeNetwork: NSObject {
    
    static let shared = TKLocalizeNetwork()
    var sessionManager = SessionManager()
    
    typealias LanguageResultHandler = ([String : String]?) -> Void
    typealias LanguagesResultHandler = ([String: [String : String]]?) -> Void
    typealias LanguageVersionHandler = (String?) -> Void
    
    override init() {
        super.init()
        // configuration network
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 30
        
        self.sessionManager = Alamofire.SessionManager(configuration: config)
    }
}

extension String {
    var jsonStringToDictionary: [String: AnyObject]? {
        if let data = data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
}

// using base -> call back json to controller
extension TKLocalizeNetwork {
    func requestLanguageVersion(_ url: String, success: @escaping LanguageVersionHandler) {
        Alamofire.request(url).responseJSON { responds in
            if let data = responds.data, let utf8Text = String(data: data, encoding: .utf8) {
                let modifiedStr = utf8Text.replacingOccurrences(of: "\u{08}", with: "", options: NSString.CompareOptions.literal, range: nil).trimmingCharacters(in: .whitespaces)
                success(modifiedStr)
            } else {
                success(nil)
            }
        }
    }
    
    func requestLanguages(_ url: String, success: @escaping LanguagesResultHandler) {
        Alamofire.request(url).responseJSON { responds in
            if let data = responds.data, let utf8Text = String(data: data, encoding: .utf8) {
                let modifiedStr = utf8Text.replacingOccurrences(of: "\u{08}", with: "", options: NSString.CompareOptions.literal, range: nil).trimmingCharacters(in: .whitespaces)
                if let dic = self.stringToJson(modifiedStr) {
                    var languages: [String : [String: String]] = [:]
                    if let vi = dic["vi"] as? [String : String] {
                        languages["vi"] = vi
                    }
                    if let en = dic["en"] as? [String : String] {
                        languages["en"] = en
                    }
                    success(languages)
                }
                success(nil)
            } else {
                success(nil)
            }
        }
    }
    
    private func stringToDictionary(_ string: String)-> [String: String]? {
        if let data = string.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String : String]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    private func stringToJson(_ string: String)-> [String: Any]? {
        if let data = string.data(using: String.Encoding.utf8) {
            do {
                if let dic = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String: Any] {
                    return dic
                } else {
                    return nil
                }
            } catch {
                return nil
            }
        }
        return nil
    }
}

