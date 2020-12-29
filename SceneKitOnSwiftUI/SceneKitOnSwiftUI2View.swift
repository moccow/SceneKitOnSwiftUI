//
//  ScenekitOnSwiftUI2View.swift
//  ScenekitOnSwiftUI
//
//  Created by masami ishiyama on 2020/12/29.
//

import SwiftUI
import SceneKit

let FINE_NAME = "screenshot.png"

struct SceneKitOnSwiftUI2View: View {
    @State var isScreenShot: Bool = false
    @State var uiImg: UIImage? = nil
    
    var body: some View {
        WrappedSceneKit2View(isScreenShot: self.$isScreenShot, uiImg: self.$uiImg)
            .frame(height: 240)
        Button(action: {
            self.isScreenShot = true
        }){
            VStack {
                Text("ScreenShot")
                if let _uiImg = self.uiImg {
                    Image(uiImage: _uiImg)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipped()
                }

            }
        }
    }}

struct WrappedSceneKit2View: UIViewRepresentable {

    @Binding var isScreenShot: Bool
    @Binding var uiImg: UIImage?

    typealias UIViewType = SCNView
    
    func makeUIView(context: Context) -> SCNView {
        
        let scene = SCNScene(named: "converse_obj.obj")
        let scnView = SCNView()
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
        
        return scnView
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
        if isScreenShot {
            // スクリーンショット保存
            DispatchQueue.main.async {
                self.uiImg = uiView.snapshot()
                let screenshot = uiView.snapshot()
                if let data = screenshot.pngData() {
                   let objFilePathUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(FINE_NAME)
                    do {
                        try data.write(to: objFilePathUrl)
                    } catch {
                        print("データ書き込み失敗")
                    }
                }
                self.isScreenShot = false
            }
        }
    }
}

struct SceneKitOnSwiftUI2View_Previews: PreviewProvider {
    static var previews: some View {
        SceneKitOnSwiftUI2View()
    }
}

