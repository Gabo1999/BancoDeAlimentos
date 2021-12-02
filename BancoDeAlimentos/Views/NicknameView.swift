//
//  NicknameView.swift
//  BancoDeAlimentos
//
//  Created by David Josué Marcial Quero on 30/11/21.
//

import SwiftUI
import ToastUI

struct NicknameView: View {
    @State private var username = ""
    @State private var presentErrorToast = false
    @State private var presentLoadingToast = false
    @EnvironmentObject var authentication: Authentication
    
    var body: some View {
        Form {
            Section {
                TextField("Username", text: $username)
                    .font(.custom("NeueHaasUnicaPro-Black", size: 15))
            }
            Section {
                Button {
                    userNameExists() { result in
                        switch result {
                        case false:
                            self.presentLoadingToast = true
                            let userRef = DonationViewModel.shared.db.collection("Users").document(APIService.shared.auth.currentUser?.uid ?? "")
                            userRef.updateData([
                                "userName": username
                            ]) { err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                    self.presentLoadingToast = false
                                } else {
                                    print("Document successfully updated")
                                    self.presentLoadingToast = false
                                    authentication.updateValidation(success: true, firstTime: false)
                                }
                            }
                        case true:
                            self.presentErrorToast = true
                            print("User name taken")
                        }
                    }
                } label: {
                    Text("Crear cuenta")
                        .font(.custom("NeueHaasUnicaPro-Black", size: 15))
                }
            }
            .disabled(disableForm)
            .toast(isPresented: $presentLoadingToast) {
                print("Tast dismissed")
            } content: {
                ToastView("Loading...")
                    .toastViewStyle(IndefiniteProgressToastViewStyle())
            }
            .toast(isPresented: $presentErrorToast, dismissAfter: 2.0) {
                ToastView("Username not available")
                    .toastViewStyle(WarningToastViewStyle())
            }
        }
    }
    
    var disableForm: Bool {
        username.count < 3 || username.isEmpty || username == "Anonimus"
    }
    
    func userNameExists(completion: @escaping (Bool) -> Void) {
        DonationViewModel.shared.db.collection("Users").whereField("userName", isEqualTo: username)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if querySnapshot!.isEmpty{
                        DispatchQueue.main.async {
                            completion(false)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(true)
                        }
                    }
                }
                
            }
    }
}

struct NicknameView_Previews: PreviewProvider {
    static var previews: some View {
        NicknameView()
    }
}
