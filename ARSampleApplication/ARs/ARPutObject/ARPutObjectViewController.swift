//
//  ARPutObjectViewController.swift
//  ARSampleApplication
//
//  Created by Yuya Imagawa on 2018/01/20.
//  Copyright © 2018年 Tobila Systems. All rights reserved.
//

import UIKit
import ARKit

struct PutObject {
    static let type = (
        box     : 0,
        ball    : 1,
        ship    : 2,
        mouse   : 3,
        pyramid : 4,
        torus   : 5
    )
}

class ARPutObjectViewController : UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var putType = PutObject.type.box
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.scene = SCNScene()
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // ライト設定
        let lightNode = SCNNode()
        let omniLight = SCNLight()
        omniLight.type = .omni
        lightNode.light = omniLight
        lightNode.position = SCNVector3(0,5,0)
        self.sceneView.scene.rootNode.addChildNode(lightNode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let pos = touch.location(in: self.sceneView)
        
        let hitTestResult = sceneView.hitTest(pos, types: .existingPlaneUsingExtent)
        if !hitTestResult.isEmpty {
            if let hitResult = hitTestResult.first {
                let obj = VirtualObjectNode.init()
                switch(self.putType) {
                    case PutObject.type.box:
                        obj.createBox(sceneView: sceneView, hitResult :hitResult)
                    case PutObject.type.ball:
                        obj.createBall(sceneView: sceneView, hitResult :hitResult)
                    case PutObject.type.ship:
                        obj.createShip(sceneView: sceneView, hitResult :hitResult)
                    case PutObject.type.mouse:
                        obj.createPikachu(sceneView: sceneView, hitResult :hitResult)
                    case PutObject.type.pyramid:
                        obj.createPyramid(sceneView: sceneView, hitResult :hitResult)
                    case PutObject.type.torus:
                        obj.createTorus(sceneView: sceneView, hitResult :hitResult)
                    default:
                        break
                }
            }
        }
    }
    
    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                node.addChildNode(ARPlaneNode(anchor: planeAnchor) )
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor, let planeNode = node.childNodes[0] as? ARPlaneNode {
                planeNode.update(anchor: planeAnchor)
            }
        }
    }
    
    // - MARK action
    @IBAction func tapBox(_ sender: Any) {
        putType = PutObject.type.box
    }
    
    @IBAction func tapBall(_ sender: Any) {
        putType = PutObject.type.ball
    }
    
    @IBAction func tapShip(_ sender: Any) {
        putType = PutObject.type.ship
    }
    
    @IBAction func tapMouse(_ sender: Any) {
        putType = PutObject.type.mouse
    }
    
    @IBAction func tapPyramid(_ sender: Any) {
        putType = PutObject.type.pyramid
    }
    
    @IBAction func tapTorus(_ sender: Any) {
        putType = PutObject.type.torus
    }
    
    
}

class VirtualObjectNode: SCNNode {
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
