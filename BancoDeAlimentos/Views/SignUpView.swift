//
//  SignUpView.swift
//  BancoDeAlimentos
//
//  Created by David Josué Marcial Quero on 14/10/21.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var loginModel: LoginModel
    @EnvironmentObject var authentication: Authentication
    
    var body: some View {
        VStack {
            Text("Crear Cuenta")
                .font(.largeTitle)
            TextField("Correo", text: $loginModel.credentials.email)
                .keyboardType(.emailAddress)
            SecureField("Password", text: $loginModel.credentials.password)
            if loginModel.showSingUpProgressView {
                ProgressView()
            }
            Button(action: {
                loginModel.signUp { success in
                    authentication.updateValidation(success: success)
                }
            }, label: {
                Text("Crear")
                    .foregroundColor(Color.white)
                    .frame(width: 200, height: 50)
                    .cornerRadius(8)
                    .background(Color.green)
            })
            .disabled(loginModel.loginDisabled)
            .padding(.bottom, 20)
            //Image("Launch Screen")
            //    .onTapGesture {
            //        UIApplication.shared.endEditing()
            //    }
            Spacer()
        }
        .autocapitalization(.none)
        .disableAutocorrection(true)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
        .disabled(loginModel.showSingUpProgressView)
        .alert(item: $loginModel.error) { error in
            Alert(title: Text("Creación de cuenta invalido"), message: Text(error.localizedDescription))
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
