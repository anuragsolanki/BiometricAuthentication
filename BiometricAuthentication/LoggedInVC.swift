//
//  LoggedInVC.swift
//  BiometricAuthentication
//
//  Created by Anurag Solanki on 16/02/18.
//  Copyright © 2018 Anurag Solanki. All rights reserved.
//

import UIKit

class LoggedInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func logoutTapped() {
        navigationController?.popViewController(animated: true)
    }

}
