//
//  ViewController.swift
//  BiometricAuthentication
//
//  Created by Anurag Solanki on 16/02/18.
//  Copyright © 2018 Anurag Solanki. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.authenticationCompletionHandler(loginStatusNotification:)), name: .BiometricAuthenticationNotificationLoginStatus, object: nil)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func loginSubmitted(_ sender: Any) {
        // Normal Login Flow with username, password authentication
        self.onLoginSuccess()
    }
    
    @IBAction func bioMetricLoginSubmitted(_ sender: Any) {
        // Will use FaceId authentication for iPhone X & Touch ID for other devices
        authenticateWithBiometric()
    }
    
    
    @objc func authenticationCompletionHandler(loginStatusNotification: Notification) {
        if let _ = loginStatusNotification.object as? BiometricAuthentication, let userInfo = loginStatusNotification.userInfo {
            if let authStatus = userInfo[BiometricAuthentication.status] as? BiometricAuthenticationStatus {
                if authStatus.success {
                    print("Login Success")
                    DispatchQueue.main.async {
                        self.onLoginSuccess()
                    }
                } else {
                    if let errorCode = authStatus.errorCode {
                        print("Login Fail with code \(String(describing: errorCode)) reason \(authStatus.errorMessage)")
                        DispatchQueue.main.async {
                            self.onLoginFail()
                        }
                        
                    }
                }
            }
        }
    }
    
    func onLoginSuccess() {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let loggedInVC = mainStoryboard.instantiateViewController(withIdentifier: "LoggedInVC")
        self.navigationController?.pushViewController(loggedInVC, animated: true)
    }
    
    func onLoginFail() {
        let alert = UIAlertController(title: "Login", message: "Login Failed", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func authenticateWithBiometric() {
        let bioAuth = BiometricAuthentication()
        bioAuth.reasonString = "To login into the app"
        bioAuth.authenticationWithBiometricID()
    }

}

