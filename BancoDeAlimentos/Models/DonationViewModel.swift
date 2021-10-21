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
    @Published var noDonations = false
    let db = Firestore.firestore()
    
    init() {
        getAllDonations()
    }
    
    func getAllDonations() {
        db.collection("Donations").order(by: "date").addSnapshotListener { (snap, error) in
            guard let docs = snap?.documents else {
                self.noDonations = true
                print("Error fetching document: \(error!)")
                return
            }
            
            if docs.count == 0 {
                self.noDonations = true
                return
            }
            
            print(docs.count)
            self.donations = docs.compactMap { queryDocumentSnapshot -> DonationModel? in
                return try? queryDocumentSnapshot.data(as: DonationModel.self)
            }
        }
    }
}