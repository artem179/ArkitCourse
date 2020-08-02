//
//  ViewController.swift
//  AR101
//
//  Created by Артем Шафаростов on 27.07.2020.
//  Copyright © 2020 Артем Шафаростов. All rights reserved.
//

import UIKit //StoryBoard
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.autoenablesDefaultLighting = true
        sceneView.session.run(ARWorldTrackingConfiguration())
        self.customScene()
    }
}

extension ViewController {
    func customScene() {
        // Plane
        sceneView.scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.intensity = 300
        sceneView.scene.rootNode.addChildNode(ambientLightNode)
        
        // Light
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.light?.intensity = 3000
        lightNode.light?.color = UIColor.orange
        lightNode.position = SCNVector3(-0.5, 0.25, -1.0)
        
        sceneView.scene.rootNode.addChildNode(lightNode)
        
        // Sphere
        let sphereNode = SCNNode()
        sphereNode.geometry = SCNSphere(radius: 0.2)
        sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.green
        sphereNode.position = SCNVector3(0, 0.5, -1.0)
        
        sceneView.scene.rootNode.addChildNode(sphereNode)
        
        // Box
        let boxNode = SCNNode()
        boxNode.geometry = SCNBox(width: 0.2,
                                  height: 0.2,
                                  length: 0.2,
                                  chamferRadius: 0.025)
        boxNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        boxNode.position.z = -0.4
        boxNode.eulerAngles = SCNVector3(0, CGFloat.pi/4, 0)
        
        sceneView.scene.rootNode.addChildNode(boxNode)
        
    }
}
