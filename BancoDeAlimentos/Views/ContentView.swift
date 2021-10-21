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
    
    var body: some View {
        NavigationView {
            TabView {
                DonationsView()
                    .tabItem {
                        Label("Donations", systemImage: "bitcoinsign.circle.fill")
                    }
                GameView()
                    .tabItem {
                        Label("Game", systemImage: "gamecontroller.fill")
                    }
                RankingView()
                    .tabItem {
                        Label("Ranking", systemImage: "rosette.star")
                    }
            }
            .padding()
            .navigationTitle("Banco de Alimentos")
            .toolbar {
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
