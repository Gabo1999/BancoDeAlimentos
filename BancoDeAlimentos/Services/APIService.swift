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
import FBSDKLoginKit

class APIService {
    let auth = Auth.auth()
    static let shared = APIService()
    @State var manager = LoginManager()
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
    
    func facebookLogIn(completion: @escaping (Result<Bool, Authentication.AuthenticationError>) -> Void){
        
        manager.logIn(permissions: [], from: nil) { (result, err) in
            if err != nil {
                print(err!.localizedDescription)
                DispatchQueue.main.async {
                    completion(.success(false))
                }
                return
            }
            
            if !result!.isCancelled {
                if AccessToken.current != nil {
                    let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                    self.auth.signIn(with: credential) { (res, err) in
                        if err != nil {
                            print((err?.localizedDescription)!)
                            return
                        }
                        DispatchQueue.main.async {
                            completion(.success(true))
                        }

                        print("Success")
                    }
                }
            }
        }
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