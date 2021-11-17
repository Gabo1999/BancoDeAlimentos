//
//  TrophiesModel.swift
//  BancoDeAlimentos
//
//  Created by David Josué Marcial Quero on 16/11/21.
//

import SwiftUI
import RealityKit
import Combine

enum TrophiesCategory: CaseIterable {
    case PremiumModel
    case NormalModel
    case WeirdModel
    
    var label: String {
        get {
            switch self {
            case .PremiumModel:
                return "Premium Model"
            case .NormalModel:
                return "Normal Model"
            case .WeirdModel:
                return "Weird Model"
            }
        }
    }
}

class TrophiesModel {
    var name: String
    var category: TrophiesCategory
    var thumbnail: UIImage
    var modelEntity: ModelEntity?
    var scaleCompensation: Float
    
    private var cancellable: AnyCancellable?
    
    init(name: String, category: TrophiesCategory, scaleCompensation: Float = 1.0) {
        self.name = name
        self.category = category
        self.thumbnail = UIImage(named: name) ?? UIImage(systemName: "photo")!
        self.scaleCompensation = scaleCompensation
    }
    
    func asyncLoadModelEntity() {
        let filename = self.name + (self.category == TrophiesCategory.PremiumModel ? ".reality" : ".usdz")
        self.cancellable = ModelEntity.loadModelAsync(named: filename)
            .sink(receiveCompletion: { loadCompletion in
                switch loadCompletion {
                case .failure(let error): print("Unable to load modelEntity for \(filename). Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { modelEntity in
                self.modelEntity = modelEntity
                self.modelEntity?.scale += self.scaleCompensation
                print("ModelEntity for \(self.name) has been loaded.")
                
            })
    }
}

struct Models {
    var all: [TrophiesModel] = []
    
    init() {
        let redFish = TrophiesModel(name: "redfish", category: .WeirdModel, scaleCompensation: 0.32/100)
        let tv_retro = TrophiesModel(name: "tv_retro", category: .NormalModel, scaleCompensation: 0.32/100)
        let astronaut = TrophiesModel(name: "CosmonautSuit_en", category: .PremiumModel, scaleCompensation: 0.32/100)
        self.all += [redFish]
        self.all += [tv_retro]
        self.all += [astronaut]
    }
    
    func get(category: TrophiesCategory) -> [TrophiesModel] {
        return all.filter( {$0.category == category} )
    }
}
