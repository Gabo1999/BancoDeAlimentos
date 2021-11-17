//
//  RankingView.swift
//  BancoDeAlimentos
//
//  Created by David Josué Marcial Quero on 21/10/21.
//

import SwiftUI
import RealityKit

struct RankingView: View {
    
    @EnvironmentObject var placementSettings: PlacementSettings
    @State private var isControlsView: Bool = true
    @State private var showBrowser: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer()
            if self.placementSettings.selectedModel == nil {
                ControlView(isControlsVisible: $isControlsView, showBrowse: $showBrowser)
            } else {
                PlacementView()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    @EnvironmentObject var placementSettings: PlacementSettings
    
    func makeUIView(context: Context) -> CustomARView {
        let arView = CustomARView(frame: .zero)
        
        // Subscribe to SceneEvents.Update
        self.placementSettings.sceneObserver = arView.scene.subscribe(to: SceneEvents.Update.self { (event) in
            self.updateScene(for: arView)
        })
        
        return arView
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {
    }
    
    private func updateScene(for arView: CustomARView) {
        
        // Only display focusEntity when the user has selected a model for placement
        arView.focusEntity?.isEnabled = self.placementSettings.selectedModel != nil
        
        if let confirmedModel = self.placementSettings.confirmedModel, let modelEntity = confirmedModel.modelEntity {
            self.place(modelEntity, in: arView)
            self.placementSettings.confirmedModel = nil
        }
    }
    
    private func place(_ modelEntity: ModelEntity, in arView: ARView) {
        let clonedEntity = modelEntity.clone(recursive: true)
        
        clonedEntity.generateCollisionShapes(recursive: true)
        arView.installGestures([.translation, .rotation], for: clonedEntity)
        
        let anchorEntity = AnchorEntity(plane: .any)
        anchorEntity.addChild(clonedEntity)
        
        arView.scene.addAnchor(anchorEntity)
        print("Added modelEntity to scene.")
    }
}

struct RankingView_Previews: PreviewProvider {
    static var previews: some View {
        RankingView()
            .environmentObject(PlacementSettings())
    }
}
