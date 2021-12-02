//
//  LoginView.swift
//  BancoDeAlimentos
//
//  Created by David Josué Marcial Quero on 14/10/21.
//

import SwiftUI
import FirebaseAuth

class LoginModel: ObservableObject {
    
    @Published var credentials = Credentials()
    @Published var showProgressView = false
    @Published var showSingUpProgressView = false
    @Published var showLogOutProgressView = false
    @Published var signUpError: Authentication.SignUpError?
    @Published var error: Authentication.AuthenticationError?
    
    
    
    var loginDisabled: Bool {
        credentials.email.isEmpty || credentials.password.isEmpty
    }
    
    func login(completion: @escaping (Bool) -> Void) {
        showProgressView = true
        APIService.shared.login(credentials: credentials) { [unowned self] (result: Result<Bool, Authentication.AuthenticationError>) in
            showProgressView = false
            switch result {
            case .success:
                completion(true)
            case .failure(let authError):
                credentials = Credentials()
                error = authError
                completion(false)
            }
        }
    }
    
    func signUp(completion: @escaping (Bool, Bool) -> Void) {
        showSingUpProgressView = true
        APIService.shared.signUp(credentials: credentials) { [unowned self] (result: Result<(Bool,Bool), Authentication.SignUpError>) in
            showSingUpProgressView = false
            switch result {
            case .success(let indicator):
                DispatchQueue.main.async {
                    completion(indicator.0, indicator.1)
                }
            case .failure(let authError):
                print("Failure")
                credentials = Credentials()
                signUpError = authError
                DispatchQueue.main.async {
                    completion(false, false)
                }
            }
        }
    }
    
    func signOut(completion: @escaping (Bool) -> Void) {
        showLogOutProgressView = true
        APIService.shared.logOut() { [unowned self] (result: Result<Bool, Authentication.SignUpError>) in
            showLogOutProgressView = false
            switch result {
            case .success:
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
    
    func googleSignIn(completion: @escaping (Bool, Bool) -> Void) {
        showProgressView = true
        APIService.shared.googleSignIn() { [unowned self] (result: Result<(Bool,Bool), Authentication.AuthenticationError>) in
            showProgressView = false
            switch result {
            case .success(let indicator):
                DispatchQueue.main.async {
                    completion(indicator.0, indicator.1)
                }
            case .failure(let authError):
                error = authError
                DispatchQueue.main.async {
                    completion(false, false)
                }
            }
        }
    }
    
    func facebookLogIn(completion: @escaping (Bool, Bool) -> Void) {
        showProgressView = true
        APIService.shared.facebookLogIn() { [unowned self] (result: Result<(Bool,Bool), Authentication.AuthenticationError>) in
            showProgressView = false
            switch result {
            case .success(let indicator):
                DispatchQueue.main.async {
                    completion(indicator.0, indicator.1)
                }
            case .failure(let authError):
                error = authError
                DispatchQueue.main.async {
                    completion(false, false)
                }
            }
        }
    }
    
}
