//
//  BiometricAuthentication.swift
//  BiometricAuthentication
//
//  Created by Anurag Solanki on 16/02/18.
//  Copyright © 2018 Anurag Solanki. All rights reserved.
//

// https://github.com/sriscode/FaceId-Authentication-IphoneX
import Foundation
import LocalAuthentication

extension Notification.Name {
    static let BiometricAuthenticationNotificationLoginStatus = Notification.Name("LoginStatus")
}

struct BiometricAuthenticationStatus {
    var success = false
    var errorCode: Int?
    var errorMessage = ""
    
    mutating func setLoginSuccess() {
        self.success = true
    }
    
    mutating func setLoginFail(errorCode: Int, errorMessage: String) {
        self.success = false
        self.errorCode = errorCode
        self.errorMessage = errorMessage
    }
}

class BiometricAuthentication {
    
    var authStatus =  BiometricAuthenticationStatus()
    //reasonString is prompted to user for login with TouchId
    var reasonString = "For biometric authentication"
    static let status = "status"
    
    func authenticationWithBiometricID() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"
        
        var authError: NSError?
        
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { success, error in
                
                if success {
                    self.authStatus.setLoginSuccess()
                    self.postNotification(userInfo: [BiometricAuthentication.status : self.authStatus])
                    
                } else {
                    guard let error = error else {
                        return
                    }
                    let errorMessage = self.errorMessageForFails(errorCode: error._code)
                    self.authStatus.setLoginFail(errorCode: error._code, errorMessage: errorMessage)
                    self.postNotification(userInfo: [BiometricAuthentication.status : self.authStatus])
                }
            }
        } else {
            
            guard let error = authError else {
                return
            }
            let errorMessage = self.errorMessageForFails(errorCode: error._code)
            self.authStatus.setLoginFail(errorCode: error._code, errorMessage: errorMessage)
            self.postNotification(userInfo: [BiometricAuthentication.status : self.authStatus])
        }
    }
    
    
    func errorMessageForFailsDeprecatediniOS11(errorCode: Int) -> String {
        var message = ""
        if #available(iOS 11.0, macOS 10.13, *) {
            message = "unknown error"
        } else {
            switch errorCode {
            case LAError.touchIDLockout.rawValue:
                message = "Authentication was not successful, because there were too many failed Touch ID attempts and Touch ID is now locked. Passcode is required to unlock Touch ID"
                
            case LAError.touchIDNotAvailable.rawValue:
                message = "Authentication could not start, because Touch ID is not available on the device"
                
            case LAError.touchIDNotEnrolled.rawValue:
                message = "Authentication could not start, because Touch ID is not enrolled on the device"
            default :
                message = "unknown error"
            }
        }
        
        return message
    }
    
    func errorMessageForFails(errorCode: Int) -> String {
        
        var message = ""
        
        switch errorCode {
        case LAError.authenticationFailed.rawValue:
            message = "Authentication was not successful, because user failed to provide valid credentials"
            
        case LAError.appCancel.rawValue:
            message = "Authentication was canceled by application"
            
        case LAError.invalidContext.rawValue:
            message = "LAContext passed to this call has been previously invalidated"
            
        case LAError.notInteractive.rawValue:
            message = "Authentication failed, because it would require showing UI which has been forbidden by using interactionNotAllowed property"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Authentication could not start, because passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was canceled by system"
            
        case LAError.userCancel.rawValue:
            message = "Authentication was canceled by user"
            
        case LAError.userFallback.rawValue:
            message = "Authentication was canceled, because the user tapped the fallback button"
            
        case LAError.biometryNotAvailable.rawValue:
            message = "Authentication could not start, because biometry is not available on the device"
            
        case LAError.biometryLockout.rawValue:
            message = "Authentication was not successful, because there were too many failed biometry attempts and                          biometry is now locked"
            
        case LAError.biometryNotEnrolled.rawValue:
            message = "Authentication could not start, because biometric authentication is not enrolled"
            
        default:
            message = self.errorMessageForFailsDeprecatediniOS11(errorCode: errorCode)
        }
        
        return message
    }
    
    func postNotification(userInfo: [String: BiometricAuthenticationStatus]) {
        NotificationCenter.default.post(name: .BiometricAuthenticationNotificationLoginStatus, object: self, userInfo: userInfo)
    }
    
    // MARK :- Use below method if you want to customise UI basis hardware capability
    /*
    func biometricType() -> String {
        let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch context.biometryType {
        case .none:
            return "none"
        case .touchID:
            return "touchID"
        case .faceID:
            return "faceID"
        }
    }
    */
}

