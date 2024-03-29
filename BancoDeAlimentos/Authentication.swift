//
//  Authentication.swift
//  BancoDeAlimentos
//
//  Created by David Josué Marcial Quero on 14/10/21.
//

import SwiftUI

class Authentication: ObservableObject {
    @Published var isValidated = false
    @Published var firstSignIn = false
    static let shared = Authentication()
    
    var isSignedIn: Bool {
        return APIService.shared.auth.currentUser != nil
    }
    
    func isSignedInValidated() -> Bool {
        if isSignedIn && !isValidated {
            updateValidation(success: isSignedIn, firstTime: firstSignIn)
        }
        return isValidated && isSignedIn
    }
    
    enum AuthenticationError: Error, LocalizedError, Identifiable {
        case invalidCredentials
        
        var id: String {
            self.localizedDescription
        }
        
        var errorDescription: String? {
            switch self {
            case.invalidCredentials:
                return NSLocalizedString("Puede que tu correo o contraseña sean incorrectos. Por favor intenta de nuevo", comment: "")
            }
        }
    }
    
    enum SignUpError: Error, LocalizedError, Identifiable {
        case invalidEmail
        
        var id: String {
            self.localizedDescription
        }
        
        var errorDescription: String? {
            switch self {
            case.invalidEmail:
                return NSLocalizedString("Tu correo es invalido", comment: "")
            }
        }
    }
    
    func updateValidation(success: Bool, firstTime: Bool) {
        withAnimation {
            print("Updating Validation: isValid: \(success); firstSignIn: \(firstTime)")
            isValidated = success
            firstSignIn = firstTime
        }
    }
}
