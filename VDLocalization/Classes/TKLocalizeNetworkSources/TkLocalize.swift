//
//  TkLocalize.swift
//  BaseProject
//
//  Created by Vu Doan on 9/20/19.
//  Copyright © 2019 translate.com. All rights reserved.
//

import Foundation
import SwiftyJSON

public let TKLocalizeNotification = "tk.notification.localization"

public class TKLocalize: NSObject {
    public static let shared = TKLocalize()
    var plist: NSMutableDictionary = [:]
    var plistSystemLanguage: NSMutableDictionary = [:]
    public static let TK_NF_LOCALIZE = NSNotification.Name(rawValue: "NTF_TK_LOCALIZE")
    public var currentLanguage : String {
        return TKLocalizeSession.shared.getLanguageCode()
    }
    
    override init() {
        super.init()
        reloadLanguagePackages()
    }
    
    public func checkPackVersion() {
        TKLocalizeNetwork.shared.requestLanguageVersion(KEY_API.tkPackageVersionURL, success: { (version) in
            if let ver = Double(version ?? "0.0"), ver > TKLocalizeSession.shared.languagePackVersion {
                TKLocalizeSession.shared.languagePackVersion = ver
                self.pullLanguagesPack()
            }
        })
    }
    
    public func setLanguage(languageCode: String) {
        TKLocalizeSession.shared.setLanguage(languageCode: languageCode)
        TKLocalizeSession.shared.isSelectedLanguage = true
        self.loadSelectedLanguage()
        NotificationCenter.default.post(name: TKLocalize.TK_NF_LOCALIZE, object: nil)
    }
    
    public func setLanguageName(languageName: String) {
        TKLocalizeSession.shared.setLanguageName(languageName: languageName)
    }
    
    public func loadLocalLanguage() {
        guard let dic = TKLocalizeReadJSONService.readJSONFromFile(fileName: "localizeSource") else { return }
        for key in dic.keys {
            if let pack = dic[key] {
                TKLocalize.shared.saveLanguage(code: key, languagePack: pack)
            }
        }
        self.reloadLanguagePackages()
        self.setLanguage(languageCode: "vi")
        self.setLanguageName(languageName: "Viet Nam")
    }
    
    private func reloadLanguagePackages() {
        self.loadSelectedLanguage()
        self.loadSystemLanguage()
    }

    private func pullLanguagesPack() {
        TKLocalizeNetwork.shared.requestLanguages(KEY_API.tkLocalizeURL, success: { (languageDics) in
            if let dic = languageDics {
                for key in dic.keys {
                    if let pack = dic[key] {
                        TKLocalize.shared.saveLanguage(code: key, languagePack: pack)
                    }
                }
                self.reloadLanguagePackages()
                NotificationCenter.default.post(name: TKLocalize.TK_NF_LOCALIZE, object: nil)
            }
        })
    }

    private func loadSelectedLanguage() {
        if TKLocalizeSession.shared.isSelectedLanguage == false {
            return
        }
        self.plist = self.loadLanguage(code: TKLocalizeSession.shared.getLanguageCode())
    }
    
    private func loadSystemLanguage() {
        self.plistSystemLanguage = self.loadLanguage(code: TKLocalizeSession.shared.systemLanguage)
    }
    
    private func loadLanguage(code: String) -> NSMutableDictionary {
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        path = path.appendingFormat("/%@.plist", code)
        
        let fileManager = FileManager.default
        
        if !fileManager.fileExists(atPath: path) {
            fileManager.createFile(atPath: path, contents: nil, attributes: [FileAttributeKey.creationDate : Date()])
        }
        // ! Because check fileExist and create new if need -> never nil
        let plistXML = FileManager.default.contents(atPath: path)!
        var propertyListFormat = PropertyListSerialization.PropertyListFormat.xml
        var plistData: NSMutableDictionary = [:]
        
        do {//convert the data to a dictionary and handle errors.
            plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListFormat) as! NSMutableDictionary
        } catch {
            print("Error reading plist: \(error), format: \(propertyListFormat)")
        }
        
        return plistData
    }
    
    private func saveLanguage(code: String, languagePack: [String : Any]) {
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        path  = path.appendingFormat("/%@.plist", code)
        
        let fileManager = FileManager.default
        
        if !fileManager.fileExists(atPath: path) {
            fileManager.createFile(atPath: path, contents: nil, attributes: [FileAttributeKey.creationDate : Date()])
        }
        // ! Because check fileExist and create new if need -> never nil
        let plistXML = FileManager.default.contents(atPath: path)!
        var propertyListFormat = PropertyListSerialization.PropertyListFormat.xml
        var plistData: NSMutableDictionary = [:]
        
        do {//convert the data to a dictionary and handle errors.
            plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListFormat) as! NSMutableDictionary
        } catch {
            print("Error reading plist: \(error), format: \(propertyListFormat)")
        }
        
        for key in languagePack.keys {
            plistData.setValue(languagePack[key], forKey: key)
        }
        plistData.write(to: URL(fileURLWithPath: path), atomically: true)
    }
    
    public func localized(key: String) -> String {
        //flow get language
        // 1. select current selected language
        // 3. if 2 not exist then select system language of device
        // 4. if 3 not exist then show the key
        
        if let valueSelectedLanguage = self.plist[key] as? String, valueSelectedLanguage.count > 0 {
            return valueSelectedLanguage
        } else if let valueSystemLanguage = self.plistSystemLanguage[key] as? String, valueSystemLanguage.count > 0 {
            return valueSystemLanguage
        }
        
        return key
    }
}

public extension String {
    var tkLocalize: String {
        return TKLocalize.shared.localized(key: self)
    }
}
