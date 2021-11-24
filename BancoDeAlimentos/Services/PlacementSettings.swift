//
//  PlacementSettings.swift
//  BancoDeAlimentos
//
//  Created by David Josué Marcial Quero on 16/11/21.
//

import SwiftUI
import RealityKit
import Combine

class PlacementSettings: ObservableObject {
    
    // When the user selects a model in BrowserView, this property is set.
    @Published var selectedModel: TrophiesModel? {
        willSet(newValue) {
            print("Setting selectedModel to \(String(describing: newValue?.name))")
        }
    }
    
    // When the user taps confirm in PlacementView, the value of a selectedModel is assigned to confirmedModel
    @Published var confirmedModel: TrophiesModel? {
        willSet(newValue) {
            guard let model = newValue else {
                print("Clearing confirmedModel")
                return
            }
            
            print("Setting confirmedModel to \(model.name)")
            self.recentlyPlaced.append(model)
        }
    }
    
    @Published var recentlyPlaced: [TrophiesModel] = []
    
    // This property retains the cancellable object for our SecneEvents.Update subscriber
    var sceneObserver: Cancellable?
}
