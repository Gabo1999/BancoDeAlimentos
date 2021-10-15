//
//  LoginView.swift
//  BancoDeAlimentos
//
//  Created by David Josué Marcial Quero on 14/10/21.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var loginModel: LoginModel
    @EnvironmentObject var authentication: Authentication
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Banco de Alimentos App")
                    .font(.largeTitle)
                TextField("Correo", text: $loginModel.credentials.email)
                    .keyboardType(.emailAddress)
                SecureField("Password", text: $loginModel.credentials.password)
                if loginModel.showProgressView {
                    ProgressView()
                }
                Button(action: {
                    loginModel.login { success in
                        authentication.updateValidation(success: success)
                    }
                }, label: {
                    Text("Ingresar")
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 50)
                        .cornerRadius(8)
                        .background(Color.green)
                })
                Spacer()
                Button(action: {
                    loginModel.googleSignIn { success in
                        authentication.updateValidation(success: success)
                    }
                }, label: {
                    Text("Ingresar con Google")
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 50)
                        .cornerRadius(8)
                        .background(Color.green)
                })
                //Image("Launch Screen")
                //    .onTapGesture {
                //        UIApplication.shared.endEditing()
                //    }
                NavigationLink(destination: SignUpView()) {
                    Text("Crear cuenta")
                }
                    .padding()
                Spacer()
            }
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .disabled(loginModel.showProgressView)
            .alert(item: $loginModel.error) { error in
                Alert(title: Text("Ingreso invalido"), message: Text(error.localizedDescription))
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
