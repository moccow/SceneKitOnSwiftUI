//
//  ScenekitOnSwiftUI4View.swift
//  ScenekitOnSwiftUI
//
//  Created by masami ishiyama on 2020/12/28.
//

import SwiftUI
import SceneKit
import SceneKit.ModelIO


struct SceneKitOnSwiftUI4View: View {
    @State var isColor: Bool = false
    var body: some View {
        WrappedSceneKit4View(isColor: self.$isColor)
            .frame(height: 240)
        Button(action: {
            self.isColor.toggle()
        }){
            Text("Texture")
        }
    }
}

struct WrappedSceneKit4View: UIViewRepresentable {
    @Binding var isColor: Bool

    typealias UIViewType = SCNView
    
    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        self.setup(scnView)
        
        return scnView
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        self.setup(uiView)
        
        // Sceneに直接オブジェクトを貼るとテクスチャをイジれないので、チャイルドノードとして持たせる
        let path = Bundle.main.path(forResource: "converse_obj", ofType: "obj")!
        let url = URL(fileURLWithPath: path)
        let modelObj = SCNMaterial()
        let objNode = SCNNode(mdlObject: MDLAsset(url: url).object(at: 0))
        objNode.geometry?.materials = [modelObj]

        //モデルが"MDL_OBJ_material0"という名前で複数保持されていくので、追加前に一度空にしておく
        uiView.scene?.rootNode.childNodes
            .filter({ $0.name == "MDL_OBJ_material0" })
            .forEach{ node in
                node.removeFromParentNode()
            }
        uiView.scene?.rootNode.addChildNode(objNode)

        // diffuse.contentsにテクスチャを指定する
        if self.isColor {
            modelObj.diffuse.contents = UIImage(named: "converse.jpg")
        } else {
            modelObj.diffuse.contents = nil
        }
    }
    
    func setup(_ scnView: SCNView) {

        let scene = SCNScene()
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
        scene.rootNode.addChildNode(lightNode)
        
        // 6: Creating and adding ambien light to scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
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

