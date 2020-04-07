//
//  HomeViewController.swift
//  BaseProject
//
//  Created by Macbook on 6/13/19.
//  Copyright © 2019 translate.com. All rights reserved.
//

import UIKit
class HomeViewController: BaseViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var changeLanguage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setLanguage() {
        headerLabel.text = "account_my_order_titile".tkLocalize
        changeLanguage.setTitle("account_order_agree_button".tkLocalize, for: .normal)
    }
    
    @IBAction func changeAction(_ sender: Any) {
        
    }
}

