//
//  ScenekitOnSwiftUI3View.swift
//  ScenekitOnSwiftUI
//
//  Created by masami ishiyama on 2020/12/28.
//

import SwiftUI
import SceneKit

struct SceneKitOnSwiftUI3View: View {
    @State var isReset: Bool = false
    var body: some View {
        WrappedSceneKit3View(isReset: self.$isReset)
            .frame(height: 240)
        Button(action: {
            self.isReset = true
        }){
            Text("Reset")
        }
    }
}

struct WrappedSceneKit3View: UIViewRepresentable {
    @Binding var isReset: Bool

    typealias UIViewType = SCNView
    
    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        self.setup(scnView)        
        return scnView
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        self.setup(uiView)
        DispatchQueue.main.async {
            self.isReset = false
        }
    }
    
    func setup(_ scnView: SCNView) {
        let scene = SCNScene(named: "converse_obj.obj")
        scnView.scene = scene

        // 2: Add camera node
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        // 3: Place camera
        cameraNode.position = SCNVector3(x: 0, y: 10, z: 35)
        // 4: Set camera on scene
//        scene.rootNode.addChildNode(cameraNode)
        
        // 5: Adding light to scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 35)
        scene?.rootNode.addChildNode(lightNode)
        
        // 6: Creating and adding ambien light to scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.color = UIColor.darkGray
        scene?.rootNode.addChildNode(ambientLightNode)
        
        // Allow user to manipulate camera
        scnView.allowsCameraControl = true
        
        // Show FPS logs and timming
        // sceneView.showsStatistics = true
        
        // Set background color
        scnView.backgroundColor = UIColor.white
        
        // Allow user translate image
        scnView.cameraControlConfiguration.allowsTranslation = false
        
        // Set scene settings
        scnView.scene = scene
    }
}
