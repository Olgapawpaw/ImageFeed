import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: "Auth token")
        }
        
        set(newValue) {
            if newValue != KeychainWrapper.standard.string(forKey: "Auth token") {
                KeychainWrapper.standard.removeObject(forKey: "Auth token")
                let isSuccess = KeychainWrapper.standard.set(newValue!, forKey: "Auth token")
                guard isSuccess else {
                    return print("error")
                }
            }
        }
    }
    
    func deleteToken() {
        KeychainWrapper.standard.removeObject(forKey: "Auth token")
    }
}

