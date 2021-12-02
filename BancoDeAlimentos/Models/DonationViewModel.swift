//
//  DonationViewModel.swift
//  BancoDeAlimentos
//
//  Created by David Josué Marcial Quero on 21/10/21.
//

import SwiftUI
import Firebase

class DonationViewModel: ObservableObject {
    @Published var donations: [DonationModel] = []
    @Published var currentUser = UserModel.dummy
    @Published var noDonations = false
    let db = Firestore.firestore()
    static let shared = DonationViewModel()
    
    func getEverything() {
        getAllDonations()
        getMyData()
    }
    
    func getAllDonations() {
        db.collection("Donations").whereField("user", isEqualTo: APIService.shared.auth.currentUser?.uid ?? "").order(by: "date").addSnapshotListener { (snap, error) in
            guard let docs = snap?.documents else {
                self.noDonations = true
                print("Error fetching document: \(error!)")
                return
            }
            
            if docs.count == 0 {
                self.noDonations = true
                print("Nothing")
                return
            }
            
            print(docs.count)
            self.donations = docs.compactMap { queryDocumentSnapshot -> DonationModel? in
                return try? queryDocumentSnapshot.data(as: DonationModel.self)
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
