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
            VStack {
                Text("AUTORIZADO")
                    .font(.largeTitle)
                if loginModel.showLogOutProgressView {
                    ProgressView()
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
