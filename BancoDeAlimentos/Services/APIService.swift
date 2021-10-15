//
//  APIService.swift
//  BancoDeAlimentos
//
//  Created by David Josué Marcial Quero on 14/10/21.
//

import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn

class APIService {
    let auth = Auth.auth()
    static let shared = APIService()
    enum APIError: Error {
        case error
    }
    
    func login(credentials: Credentials,
               completion: @escaping (Result<Bool, Authentication.AuthenticationError>) -> Void) {
        
 //       let credential = EmailAuthProvider.credential(withEmail: credentials.email, password: credentials.password)
        
//        auth.currentUser?.link(with: credential) { authResul, error in
//            guard error == nil else {
//                DispatchQueue.main.async {
//                    completion(.failure(.invalidCredentials))
//                }
//                return
//            }
//            DispatchQueue.main.async {
//                completion(.success(true))
//            }
//
//        }
        auth.signIn(withEmail: credentials.email, password: credentials.password) { result, error in
            guard result != nil, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidCredentials))
                }
                return
            }
            DispatchQueue.main.async {
                completion(.success(true))
            }
        }
    }
    
    func signUp(credentials: Credentials, completion: @escaping (Result<Bool, Authentication.SignUpError>) -> Void) {
        auth.createUser(withEmail: credentials.email, password: credentials.password) { result, error in
            guard result != nil, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidEmail))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(true))
            }
        }
    }
    
    func logOut(completion: @escaping (Result<Bool, Authentication.SignUpError>) -> Void) {
        try? auth.signOut()
        completion(.success(true))
    }
    
    func googleSignIn(completion: @escaping (Result<Bool, Authentication.AuthenticationError>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: (UIApplication.shared.windows.first?.rootViewController)!) { [unowned self] user, error in
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(.failure(.invalidCredentials))
                }
                return
            }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return
            }
            
            let credential =
                GoogleAuthProvider.credential(withIDToken:
                idToken, accessToken:
                authentication.accessToken)
            
//            auth.currentUser?.link(with: credential) { authResult, error in
//                if error != nil {
//                    DispatchQueue.main.async {
//                        completion(.failure(.invalidCredentials))
//                    }
//                    return
//                }
//                DispatchQueue.main.async {
//                    completion(.success(true))
//                }
//            }
            auth.signIn(with: credential) { result, error in
                if error != nil {
                    DispatchQueue.main.async {
                        completion(.failure(.invalidCredentials))
                    }
                    return
                }
                DispatchQueue.main.async {
                    completion(.success(true))
                }

            }
        }
    }
}
