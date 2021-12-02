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
        navBarAppearance.backgroundColor = UIColor(Color("CaritasColorPrincipal"))
        navBarAppearance.shadowColor = UIColor.black
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().tintColor = UIColor.systemBackground
        UITableView.appearance().backgroundColor = UIColor(Color("CaritasColorSecundario"))
    }
    @State var x = -UIScreen.main.bounds.width + 90
    var body: some View {
        TabView {
            NavigationView {
                DonationsView(x: $x)
                .navigationBarTitle("Donaciones")
                .toolbar {
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Text("Donaciones")
//                            .font(.largeTitle)
//                            .fontWeight(.heavy)
//                            .foregroundColor(.black)
//                    }
//                        ToolbarItem(placement: .navigationBarLeading) {
//                            NavigationLink(destination: NewDonationView()) {
//                                Image(systemName: "plus.circle")
//                                    .font(.title)
//                                    .foregroundColor(Color(.black))
//                            }
//                        }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            withAnimation {
                                x = 0
                            }
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .font(.system(size: 24))
                                .foregroundColor(Color.white)
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
            NavigationView {
                RankingView()
                .navigationBarTitle("Ranking")
            }
            .tabItem {
                Label("Ranking", systemImage: "rosette")
            }
        }
        .accentColor(Color("CaritasColorPrincipal"))
        .background(Color("CaritasColorSecundario").ignoresSafeArea(.all, edges: .all))
//            .ignoresSafeArea(.all, edges: .top)
//            .navigationBarTitle("Alimentos")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
