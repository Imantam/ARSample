//
//  common.swift
//  ARSampleApplication
//
//  Created by Yuya Imagawa on 2018/01/17.
//  Copyright © 2018年 Tobila Systems. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

extension UIColor {
    class var arBlue: UIColor {
        get {
            return UIColor(red: 0.141, green: 0.540, blue: 0.816, alpha: 1)
        }
    }
}

extension ARSession {
    func run() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
}

extension SCNNode {
    
    class func sphereNode(color: UIColor) -> SCNNode {
        let geometry = SCNSphere(radius: 0.01)
        geometry.materials.first?.diffuse.contents = color
        return SCNNode(geometry: geometry)
    }
    
    class func lineNode(length: CGFloat, color: UIColor) -> SCNNode {
        let geometry = SCNCapsule(capRadius: 0.004, height: length)
        geometry.materials.first?.diffuse.contents = color
        let line = SCNNode(geometry: geometry)
        
        let node = SCNNode()
        node.eulerAngles = SCNVector3Make(Float.pi/2, 0, 0)
        node.addChildNode(line)
        
        return node
    }
    
    // 箱
    func createBox(sceneView : SCNView, hitResult: ARHitTestResult) {
        let boxGeometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "block")
        boxGeometry.materials = [material]
        
        let boxNode = SCNNode(geometry: boxGeometry)
        boxNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: boxGeometry, options: [:]))
        boxNode.physicsBody?.categoryBitMask = 1
        boxNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y + 0.4, hitResult.worldTransform.columns.3.z)
        
        sceneView.scene?.rootNode.addChildNode(boxNode)
    }
    
    // 球
    func createBall(sceneView : SCNView, hitResult: ARHitTestResult) {
        let ballGeometry = SCNSphere(radius: 0.05)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "ball")
        ballGeometry.materials = [material]
        
        let ballNode = SCNNode(geometry: ballGeometry)
        ballNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: ballGeometry, options: [:]))
        ballNode.physicsBody?.categoryBitMask = 1
        // タップした位置より指定した0.4m落下する
        ballNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y + 0.4, hitResult.worldTransform.columns.3.z)
        
        sceneView.scene?.rootNode.addChildNode(ballNode)
    }
    
    // 三角錐
    func createPyramid(sceneView : SCNView, hitResult: ARHitTestResult) {
        let pyramidGeometry = SCNPyramid(width: 0.1, height: 0.1, length: 0.1)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "pyramid")
        pyramidGeometry.materials = [material]
        
        let pyramidNode = SCNNode(geometry: pyramidGeometry)
        pyramidNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: pyramidGeometry, options: [:]))
        pyramidNode.physicsBody?.categoryBitMask = 1
        // タップした位置より指定した0.4m落下する
        pyramidNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y + 0.4, hitResult.worldTransform.columns.3.z)
        
        sceneView.scene?.rootNode.addChildNode(pyramidNode)
    }
    
    // ドーナツ
    func createTorus(sceneView : SCNView, hitResult: ARHitTestResult) {
        let torusGeometry = SCNTorus(ringRadius: 0.05, pipeRadius: 0.02)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "torus")
        torusGeometry.materials = [material]
        
        let torusNode = SCNNode(geometry: torusGeometry)
        torusNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: torusGeometry, options: [:]))
        torusNode.physicsBody?.categoryBitMask = 1
        // タップした位置より指定した0.4m落下する
        torusNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y + 0.4, hitResult.worldTransform.columns.3.z)
        
        sceneView.scene?.rootNode.addChildNode(torusNode)
    }
    
    // 船
    func createShip(sceneView : SCNView, hitResult: ARHitTestResult) {
        guard let scene = SCNScene(named: "ship.scn", inDirectory: "art.scnassets")  else {fatalError()}
        let ship = scene.rootNode.childNode(withName: "ship", recursively: true)!
        ship.scale = SCNVector3(0.1, 0.1, 0.1)
        ship.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        ship.physicsBody?.categoryBitMask = 1

        // タップした位置より指定した0.4m落下する
        ship.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y + 0.4, hitResult.worldTransform.columns.3.z)

        sceneView.scene?.rootNode.addChildNode(ship)
    }
    
    // ピカチュウ
    func createPikachu(sceneView : SCNView, hitResult: ARHitTestResult) {
        guard let scene = SCNScene(named: "PikachuF_ColladaMax.scn", inDirectory: "art.scnassets")  else {fatalError()}
        let nodes = scene.rootNode.childNodes
        for node in nodes {
            node.scale = SCNVector3(0.002, 0.002, 0.002)
            node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: node, options: nil))
            node.physicsBody?.categoryBitMask = 1
            
            // タップした位置より指定した0.5m落下する
            node.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y + 0.5, hitResult.worldTransform.columns.3.z)
            sceneView.scene?.rootNode.addChildNode(node)
        }
    }
}

extension SCNView {
    
    private func enableEnvironmentMapWithIntensity(_ intensity: CGFloat) {
        if scene?.lightingEnvironment.contents == nil {
            if let environmentMap = UIImage(named: "models.scnassets/sharedImages/environment_blur.exr") {
                scene?.lightingEnvironment.contents = environmentMap
            }
        }
        scene?.lightingEnvironment.intensity = intensity
    }
    
    func updateLightingEnvironment(for frame: ARFrame) {
        // If light estimation is enabled, update the intensity of the model's lights and the environment map
        let intensity: CGFloat
        if let lightEstimate = frame.lightEstimate {
            intensity = lightEstimate.ambientIntensity / 400
        } else {
            intensity = 2
        }
        DispatchQueue.main.async(execute: {
            self.enableEnvironmentMapWithIntensity(intensity)
        })
    }
}


