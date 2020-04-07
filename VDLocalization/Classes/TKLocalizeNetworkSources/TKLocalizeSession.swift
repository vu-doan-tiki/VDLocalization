//
//  Session.swift
//  Ebates
//
//  Created by Macbook on 10/9/18.
//  Copyright © 2018 personal. All rights reserved.
//

import Foundation

public class TKLocalizeSession: NSObject {
   
    public static let shared = TKLocalizeSession()
    
    override init() {
        super.init()
        self.loadDefault()
    }
    
    public var isFirstTime: Bool = false {
        didSet {
            let userDef = UserDefaults.standard
            userDef.setValue(isFirstTime, forKey: CONSTANT.keyIsFirstTime)
        }
    }
    
    // for checking first select language
    public var isSelectedLanguage: Bool = false {
        didSet {
            let userDef = UserDefaults.standard
            userDef.setValue(isSelectedLanguage, forKey: CONSTANT.keyIsSelectedLanguage)
        }
    }
    
    // current language code
    private var languageCode: String = CONSTANT.keySystemLanguage {
        didSet {
            let userDef = UserDefaults.standard
            userDef.setValue(languageCode, forKey: CONSTANT.keyLanguageCode)
        }
    }
    
    // current language Name
    private var languageName: String = "" {
        didSet {
            let userDef = UserDefaults.standard
            userDef.setValue(languageName, forKey: CONSTANT.keyLanguageName)
        }
    }
    // system language
    public var systemLanguage: String = "en"
    
    // language pack version
    public var languagePackVersion: Double = 0 {
        didSet {
            let userDef = UserDefaults.standard
            userDef.set(languagePackVersion, forKey: CONSTANT.keyLanguagePackVersion)
        }
    }
    
    public func getLanguageCode() -> String {
        return self.languageCode
    }
    
    public func getLanguageName() -> String {
        return self.languageName
    }

    public func setLanguage(languageCode: String) {
        self.languageCode = languageCode
    }
    
    public func setLanguageName(languageName: String) {
        self.languageName = languageName
    }
    
    public func loadDefault() {
        let userDef = UserDefaults.standard
        self.languageCode = (userDef.object(forKey: CONSTANT.keyLanguageCode) ?? "vi") as! String
        self.isFirstTime = (userDef.object(forKey: CONSTANT.keyIsFirstTime) ?? false) as! Bool
        self.isSelectedLanguage = (userDef.object(forKey: CONSTANT.keyIsSelectedLanguage) ?? false) as! Bool
        self.languageName = (userDef.object(forKey: CONSTANT.keyLanguageName) ?? "") as! String
        self.languagePackVersion = (userDef.object(forKey: CONSTANT.keyLanguagePackVersion) ?? Double(0)) as! Double
    }
}
