//
//  LoginView.swift
//  BancoDeAlimentos
//
//  Created by David Josué Marcial Quero on 14/10/21.
//

import SwiftUI
import Firebase
import FBSDKLoginKit

//struct LoginFacebookButton: UIViewRepresentable {
//
//    @EnvironmentObject var authentication: Authentication
//    @EnvironmentObject var loginModel: LoginModel
//    @State var isValidated = false
//
//    func makeCoordinator() -> Coordinator {
//        return LoginFacebookButton.Coordinator()
//    }
//
//    func makeUIView(context: UIViewRepresentableContext<LoginFacebookButton>) -> FBLoginButton {
//        let button = FBLoginButton()
//        button.delegate = context.coordinator
//        return button
//    }
//
//    func updateUIView(_ uiView: FBLoginButton, context: UIViewRepresentableContext<LoginFacebookButton>) {
//
//    }
//
//    class Coordinator: NSObject, LoginButtonDelegate {
//
//        func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
//            if error != nil {
//                print((error?.localizedDescription)!)
//                return
//            }
//            APIService.shared.facebookLogIn()
//        }
//
//        func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
//            try!APIService.shared.auth.signOut()
//        }
//
//
//    }
//}


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
                        .background(Color.orange)
                })
                .padding()
                HStack{
                    Button(action: {
                        loginModel.googleSignIn { success in
                            authentication.updateValidation(success: success)
                        }
                    }, label: {
                        Text("Ingresar con Google")
                            .foregroundColor(Color.white)
                            .frame(width: 200, height: 50)
                            .cornerRadius(8)
                            .background(Color.orange)
                    })
                    Button(action: {
                        loginModel.facebookLogIn { success in
                            authentication.updateValidation(success: success)
                        }
                    }, label: {
                        Text("Continue with Facebook")
                            .foregroundColor(Color.white)
                            .frame(width: 200, height: 50)
                            .cornerRadius(8)
                            .background(Color.green)
                    })
                }
//                LoginFacebookButton().frame(width: 100, height: 50, alignment: .center)
//                    .environmentObject(authentication)
//                    .environmentObject(loginModel)
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
