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
        auth.createUser(withEmail: credentials.email, password: credentials.password) { [self] result, error in
            guard result != nil, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidEmail))
                }
                print(error ?? "Something")
                return
            }
            
            createUserDocument(id: result!.user.uid) { result in
                DispatchQueue.main.async {
                    completion(.success(true))
                }

                print("Success")
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
                    self.auth.signIn(with: credential) { [self] (res, err) in
                        if err != nil {
                            print((err?.localizedDescription)!)
                            return
                        }
                        
                        createUserDocument(id: res!.user.uid) { result in
                            DispatchQueue.main.async {
                                completion(.success(true))
                            }

                            print("Success")
                        }
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
                
                createUserDocument(id: result!.user.uid) { result in
                    DispatchQueue.main.async {
                        completion(.success(true))
                    }

                    print("Success")
                }
            }
        }
    }
    
    func createUserDocument(id: String, completion: @escaping (Bool) -> Void) {
        documentExists(collection: "Users", id: id) { result in
            if result {
                completion(true)
                print("Success")
            } else {
                DonationViewModel.shared.db.collection("Users").document(id).setData([
                    "donationPoints": 0,
                    "highestGameScore": 0,
                    "userType": "Student"
                ]) { err in
                    if let err = err {
                        print("Error writing new User document: \(err)")
                        completion(false)
                    } else {
                        print("User's document successfully written!")
                        completion(true)
                    }
                }
            }
        }
    }
    
    func documentExists(collection: String, id: String, completion: @escaping (Bool) -> Void){
        let docRef = DonationViewModel.shared.db.collection(collection).document(id)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(true)
            } else {
                completion(false)
            }
        }
        completion(false)
    }
}
