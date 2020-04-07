//
//  BaseViewController.swift
//  BestDealMedication
//
//  Created by Macbook on 12/6/18.
//  Copyright © 2018 company. All rights reserved.
//

import UIKit
import VDLocalization

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.setLanguage), name: TKLocalize.TK_NF_LOCALIZE, object: nil)
        setLanguage()
    }
    
    @objc func setLanguage() {
        
    }
}
