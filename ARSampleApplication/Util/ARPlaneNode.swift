//
//  ARPlaneNode.swift
//  ARSampleApplication
//
//  Created by Yuya Imagawa on 2018/01/17.
//  Copyright © 2018年 Tobila Systems. All rights reserved.
//

import Foundation
import ARKit

class ARPlaneNode : SCNNode {
    
    fileprivate override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(anchor: ARPlaneAnchor) {
        super.init()
        
        geometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        let planeMaterial = SCNMaterial()
        planeMaterial.diffuse.contents = UIColor.blue.withAlphaComponent(0.2)
        geometry?.materials = [planeMaterial]
        SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        
        physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: geometry!, options: nil))
        physicsBody?.categoryBitMask = 2
    }
    
    func update(anchor: ARPlaneAnchor) {
        (geometry as! SCNPlane).width = CGFloat(anchor.extent.x)
        (geometry as! SCNPlane).height = CGFloat(anchor.extent.z)
        position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        
        physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: geometry!, options: nil))
        physicsBody?.categoryBitMask = 2
    }
}
