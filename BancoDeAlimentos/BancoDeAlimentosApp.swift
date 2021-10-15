//
//  BancoDeAlimentosApp.swift
//  BancoDeAlimentos
//
//  Created by David Josué Marcial Quero on 14/10/21.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
struct BancoDeAlimentosApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var authentication = Authentication()
    @StateObject var loginModel = LoginModel()
    
    var body: some Scene {
        WindowGroup {
            if authentication.isSignedInValidated() {
                ContentView()
                    .environmentObject(authentication)
                    .environmentObject(loginModel)
            } else {
                LoginView()
                    .environmentObject(authentication)
                    .environmentObject(loginModel)
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
