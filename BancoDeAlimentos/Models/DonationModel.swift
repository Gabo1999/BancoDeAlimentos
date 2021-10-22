//
//  DonationModel.swift
//  BancoDeAlimentos
//
//  Created by David Josué Marcial Quero on 21/10/21.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct DonationModel: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var picture: String
    var date: Date
    var points: Int
    var user: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case picture
        case date
        case points
        case user
    }
}

extension DonationModel {
    static let dummy = DonationModel(title: "Donación 1", picture: "picture", date: Date(), points: 15, user: "EEEDD")
}
