//
//  ARDrawingViewController.swift
//  ARSampleApplication
//
//  Created by Yuya Imagawa on 2018/01/20.
//  Copyright © 2018年 Tobila Systems. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ARDrawingViewController: UIViewController, ARSCNViewDelegate {
    
    private var drawingNodes = [DynamicGeometryNode]()

    private var isTouching = false {
        didSet {
            pen.isHidden = !isTouching
        }
    }
    private var dx : CGFloat = 0.0
    private var dy : CGFloat = 0.0
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var pen: UILabel!
    @IBOutlet var resetBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.scene = SCNScene()
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]

        statusLabel.text = "準備中"
        pen.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.session.run()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    // MARK: - Private
    
    private func reset() {
        for node in drawingNodes {
            node.removeFromParentNode()
        }
        drawingNodes.removeAll()
    }
    
    private func isReadyForDrawing(trackingState: ARCamera.TrackingState) -> Bool {
        switch trackingState {
        case .normal:
            return true
        default:
            return false
        }
    }
    
    private func worldPositionForScreen(x: CGFloat, y: CGFloat) -> SCNVector3 {
        let centerVec3 = SCNVector3Make(Float(x), Float(y), 1.02)
        return sceneView.unprojectPoint(centerVec3)
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard isTouching else {return}
        guard let currentDrawing = drawingNodes.last else {return}
        
        DispatchQueue.main.async(execute: {
            let vertice = self.sceneView.unprojectPoint(SCNVector3Make(Float(self.dx), Float(self.dy), 0.99))
            currentDrawing.addVertice(vertice)
        })
    }

    // MARK: - ARSessionObserver

    func session(_ session: ARSession, didFailWithError error: Error) {
        print("\(self.classForCoder)/\(#function), error: " + error.localizedDescription)
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        print("trackingState: \(camera.trackingState)")
        
        let state = camera.trackingState
        let isReady = isReadyForDrawing(trackingState: state)
        statusLabel.text = isReady ? "タップすると線の描画が始まります" : ("準備中...\n\(state.description)")
    }
    
    // MARK: - Touch Handlers
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let frame = sceneView.session.currentFrame else {return}
        guard isReadyForDrawing(trackingState: frame.camera.trackingState) else {return}
        
        // 座標取得
        let touchEvent = touches.first!
        dx = touchEvent.location(in: self.view).x
        dy = touchEvent.location(in: self.view).y
        
        let drawingNode = DynamicGeometryNode(color: UIColor.blue, lineWidth: 0.005)
        sceneView.scene.rootNode.addChildNode(drawingNode)
        drawingNodes.append(drawingNode)

        statusLabel.text = "端末を動かすと線が描画されます。"

        isTouching = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 座標取得
        let touchEvent = touches.first!
        dx = touchEvent.location(in: self.view).x
        dy = touchEvent.location(in: self.view).y
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouching = false
        statusLabel.text = "タップすると線の描画が始まります"
    }
    
    // MARK: - Actions

    @IBAction func resetBtnTapped(_ sender: UIButton) {
        reset()
    }
}

open class DynamicGeometryNode: SCNNode {
    private var vertices: [SCNVector3] = []
    private var indices: [Int32] = []
    private let lineWidth: Float
    private let color: UIColor
    private var verticesPool: [SCNVector3] = []
    
    public init(color: UIColor, lineWidth: Float) {
        self.color = color
        self.lineWidth = lineWidth
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addVertice(_ vertice: SCNVector3) {
        var smoothed = SCNVector3Zero
        if verticesPool.count < 3 {
            if !SCNVector3EqualToVector3(vertice, SCNVector3Zero) {
                verticesPool.append(vertice)
            }
            return
        } else {
            for vertice in verticesPool {
                smoothed += vertice
            }
            smoothed /= Float(verticesPool.count)
            verticesPool.removeAll()
        }
        vertices.append(SCNVector3Make(smoothed.x, smoothed.y - lineWidth, smoothed.z))
        vertices.append(SCNVector3Make(smoothed.x, smoothed.y + lineWidth, smoothed.z))

        let count = vertices.count
        indices.append(Int32(count-2))
        indices.append(Int32(count-1))
        
        updateGeometryIfNeeded()
    }
    
    private func updateGeometryIfNeeded() {
        guard vertices.count >= 3 else {
            return
        }
        let source = SCNGeometrySource(vertices: vertices)
        let element = SCNGeometryElement(indices: indices, primitiveType: .triangleStrip)
        geometry = SCNGeometry(sources: [source], elements: [element])
        if let material = geometry?.firstMaterial {
            material.diffuse.contents = color
            material.isDoubleSided = true
        }
    }
}

