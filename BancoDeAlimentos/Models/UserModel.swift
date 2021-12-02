//
//  UserModel.swift
//  BancoDeAlimentos
//
//  Created by David Josué Marcial Quero on 01/12/21.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct UserModel: Identifiable, Codable {
    @DocumentID var id: String?
    var userName: String
    var userType: String
    var score: Int
    var energy: Int
    var diamonds: Int
    var powerLvl: Int
    var magicPowerLvl: Int
    var timerLvl: Int
    var lastLogin: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userName
        case userType
        case score
        case energy
        case diamonds
        case powerLvl
        case magicPowerLvl
        case timerLvl
        case lastLogin
    }
}

extension UserModel {
    static let dummy = UserModel(userName: "Quero", userType: "Student", score: 0, energy: 0, diamonds: 0, powerLvl: 0, magicPowerLvl: 0, timerLvl: 0, lastLogin: "00/00/00")
}
