//
//  TKLocalizeProperties+Extension.swift
//  TKLocalization
//
//  Created by Vu Doan on 9/25/19.
//  Copyright © 2019 Vu Doan. All rights reserved.
//

import Foundation
import UIKit

public extension UILabel {
    @IBInspectable
    open var localize: String {
        get {
            return self.localize
        }
        set(value) {
            self.text = value.tkLocalize
        }
    }
}

public extension UITextField {
    @IBInspectable
    open var localize: String {
        get {
            return self.localize
        }
        set(value) {
            self.placeholder = value.tkLocalize
        }
    }
}

public extension UIButton {
    @IBInspectable
    open var localize: String {
        get {
            return self.localize
        }
        set(value) {
            
            self.setTitle(value.tkLocalize, for: .normal)
        }
    }
}
