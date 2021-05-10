//
//  SharedSettings.swift
//  Cards
//
//  Created by Linda Zungu on 2021/05/10.
//
//This class makes all things in here known and shareable across all views and classes in the app 

import Foundation
import LocalAuthentication

class SharedSettings: ObservableObject{
    @Published var isUnlocked = false
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "Passcode required to gain access to your data."

            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                DispatchQueue.main.async {
                    if success {
                        // authenticated successfully
                        self.isUnlocked = true
                    } else {
                        // there was a problem
                        print("Biometric failed")
                        
                    }
                }
            }
        } else {
            // no biometrics allowed: Fix this!
            print("No biometrics allowed")
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "") { success, authenticationError in
                // authentication has now completed
                DispatchQueue.main.async {
                    if success {
                        // authenticated successfully
                        self.isUnlocked = true
                    } else {
                        // there was a problem
                    }
                }
            }
        }
    }
}
