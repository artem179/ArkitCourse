//
//  ViewController.swift
//  ImageDetection
//
//  Created by Artem Shafarostov on 30.07.2020.
//  Copyright © 2020 Artem Shafarostov. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer,
                  didAdd node: SCNNode,
                  for anchor: ARAnchor) {
        guard let imageAnchor: ARImageAnchor = anchor as? ARImageAnchor,
              let _ = imageAnchor.referenceImage.name
            else { return }
        
        anchorsArray.append(imageAnchor)
        
        if anchorsArray.first != nil {
            node.addChildNode(planetariumNode)
        }
        
        if anchorsArray.last != nil {
            node.addChildNode(planetariumNode)
        }
    }
}

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    let planetariumNode = SCNNode()
    var anchorsArray: [ARImageAnchor] = []
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self

        let scene = SCNScene()
        sceneView.scene = scene
        self.resetTrackingConfig()
        
        //Create Earth orbit
        let earthOrbit = SCNNode()
        earthOrbit.position = SCNVector3(0, -0.0, 0.0)
        planetariumNode.addChildNode(earthOrbit)
        
        //Create lightning for Sun
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.light?.intensity = 3000
        
        // Sun
        let sunNode = SCNNode(geometry: SCNSphere(radius: 0.08))
        // sunNode.geometry = SCNSphere()
        sunNode.position = SCNVector3(0, -0.0, 0.0)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/sunAlbedo.jpg")
        material.emission.contents = UIImage(named: "art.scnassets/sunEmission.jpg")
        material.emission.intensity = 1.5
        
        sunNode.geometry?.firstMaterial = material
        planetariumNode.addChildNode(sunNode)
        sunNode.addChildNode(lightNode)
        
        //Earth
        let earthNode = SCNNode(geometry: SCNSphere(radius: 0.03))
        earthNode.position = SCNVector3(-0.25, -0.0, -0.0)
        earthNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/earthAlbedo.jpg")
        earthNode.geometry?.firstMaterial?.emission.contents = UIImage(named: "art.scnassets/earthEmission.jpg")
        earthNode.geometry?.firstMaterial?.emission.intensity = 1.0
        
        //earthNode.geometry?.firstMaterial = material
        //planetariumNode.addChildNode(earthNode)
        
        //Create Moon orbit
        let moonOrbit = SCNNode()
        moonOrbit.position = SCNVector3(-0.25, -0.0, 0.0)
        earthOrbit.addChildNode(moonOrbit)
        
        earthOrbit.addChildNode(earthNode)
        
        //Moon
        let moonNode = SCNNode(geometry: SCNSphere(radius: 0.01))
        //moonNode.position = SCNVector3(-1.0, -2.0, -0.5)
        moonNode.position = SCNVector3(-0.05, 0.0, 0.0)
        moonNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/moonAlbedo.jpg")
        //moonNode.geometry?.firstMaterial = material
        //planetariumNode.addChildNode(moonNode)
        moonOrbit.addChildNode(moonNode)
        
        //Planet actions
        let actionMoon = SCNAction.repeatForever(SCNAction.rotate(by: 2 * .pi, around: SCNVector3(0, 0, -1), duration: 5))
        let actionSun = SCNAction.repeatForever(SCNAction.rotate(by: .pi/4, around: SCNVector3(0, 0, -1), duration: 5))
        let actionEarth = SCNAction.repeatForever(SCNAction.rotate(by: .pi/2, around: SCNVector3(0, 0, -1), duration: 5))
        
        let actionMoonOrbit = SCNAction.repeatForever(SCNAction.rotate(by: 24 * .pi, around: SCNVector3(0, 0, -1), duration: 5))
        let actionEarthOrbit = SCNAction.repeatForever(SCNAction.rotate(by: .pi, around: SCNVector3(0, 0, -1), duration: 5))
        
        
        sunNode.runAction(actionSun)
        earthNode.runAction(actionEarth)
        moonNode.runAction(actionMoon)
        
        earthOrbit.runAction(actionEarthOrbit)
        moonOrbit.runAction(actionMoonOrbit)
    }
    
    func resetTrackingConfig() {
        guard let refImage: Set<ARReferenceImage> =
            ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)
            else { return }
        
        //let config = ARImageTrackingConfiguration()
        let config = ARWorldTrackingConfiguration()
        
        //config.trackingImages = refImage
        config.detectionImages = refImage
        config.maximumNumberOfTrackedImages = 1
        
        let options = ARSession.RunOptions([ARSession.RunOptions.removeExistingAnchors,
                       ARSession.RunOptions.resetTracking])
        
        sceneView.session.run(config, options: options)
        
    }
    
    @IBAction func reset(_ sender: UIButton) {
        resetTrackingConfig()
    }
}
