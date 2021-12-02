//
//  RankingModel.swift
//  BancoDeAlimentos
//
//  Created by David Josué Marcial Quero on 01/12/21.
//

import SwiftUI
import Firebase

class RankingModel: ObservableObject {
    @Published var topTenUsers: [UserModel] = []
    @Published var currentUser = UserModel.dummy
    @Published var noUsers = false
    let db = Firestore.firestore()
    static let shared = RankingModel()
    
    init() {
        getTopTenUsers()
        getMyData()
    }
    
    func getTopTenUsers() {
        db.collection("Users").order(by: "score", descending: true).limit(to: 10).addSnapshotListener { (snap, error) in
            guard let docs = snap?.documents else {
                self.noUsers = true
                print("Error fetching document: \(error!)")
                return
            }
            
            if docs.count == 0 {
                self.noUsers = true
                print("Nothing")
                return
            }
            
            print(docs.count)
            self.topTenUsers = docs.compactMap { queryDocumentSnapshot -> UserModel? in
                return try? queryDocumentSnapshot.data(as: UserModel.self)
            }
        }
    }
    
    func getMyData() {
        db.collection("Users").document(APIService.shared.auth.currentUser?.uid ?? "")
        .addSnapshotListener { (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(String(describing: error))")
                return
            }
            let result = Result {
                try document.data(as: UserModel.self)
            }
            switch result {
            case .success(let user):
                print("User obtained")
                self.currentUser = user!
            case .failure(let error):
                print("Error decoding user: \(error)")
            }
        }
    }
}
