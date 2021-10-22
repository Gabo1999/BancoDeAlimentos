//
//  ContentView.swift
//  BancoDeAlimentos
//
//  Created by David Josué Marcial Quero on 14/10/21.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authentication: Authentication
    @EnvironmentObject var loginModel: LoginModel
    
    init() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.systemBackground]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.systemBackground]
        navBarAppearance.backgroundColor = UIColor.orange
        navBarAppearance.shadowColor = UIColor.black
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().tintColor = UIColor.systemBackground
    }
    
    var body: some View {
        TabView {
            NavigationView {
                DonationsView()
                .navigationBarTitle("Donaciones")
                .toolbar {
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Text("Donaciones")
//                            .font(.largeTitle)
//                            .fontWeight(.heavy)
//                            .foregroundColor(.black)
//                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Salir") {
                            loginModel.signOut { result in
                                print(result)
                                authentication.updateValidation(success: !result)
                            }
                        }
                    }
                }
            }
            .tabItem {
                Label("Donations", systemImage: "bitcoinsign.circle.fill")
            }
            GameView()
                .tabItem {
                    Label("Game", systemImage: "gamecontroller.fill")
                }
            RankingView()
                .tabItem {
                    Label("Ranking", systemImage: "rosette")
                }
        }
        .accentColor(.orange)
//            .background(Color(.green).ignoresSafeArea(.all, edges: .all))
//            .ignoresSafeArea(.all, edges: .top)
//            .navigationBarTitle("Alimentos")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
