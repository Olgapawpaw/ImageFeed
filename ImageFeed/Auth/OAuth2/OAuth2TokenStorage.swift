import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    // MARK: - Public Properties
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
    
    // MARK: - Public Methods
    func deleteToken() {
        KeychainWrapper.standard.removeObject(forKey: "Auth token")
    }
}

