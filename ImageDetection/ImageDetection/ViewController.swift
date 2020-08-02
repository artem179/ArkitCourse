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
        
        // Sun
        let sunNode = SCNNode(geometry: SCNSphere(radius: 0.2))
        // sunNode.geometry = SCNSphere()
        sunNode.position = SCNVector3(0, 0, -0.5)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/sunAlbedo.jpg")
        material.emission.contents = UIImage(named: "art.scnassets/sunEmission.jpg")
        material.emission.intensity = 1.5
        
        sunNode.geometry?.firstMaterial = material
        planetariumNode.addChildNode(sunNode)
        
        //Earth
        let earthNode = SCNNode(geometry: SCNSphere(radius: 0.1))
        earthNode.position = SCNVector3(-0.3, 0.0, 0.0)
        earthNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/earthAlbedo.jpg")
        earthNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/earthEmission.jpg")
        
        earthNode.geometry?.firstMaterial = material
        planetariumNode.addChildNode(sunNode)
        
        //Moon
        
        SCNAction.repeatForever(SCNAction())
        
    }
    
    func resetTrackingConfig() {
        guard let refImage: Set<ARReferenceImage> =
            ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)
            else { return }
        
        let config = ARImageTrackingConfiguration()
        
        config.videoFormat.framesPerSecond
        config.trackingImages = refImage
        //config.detectionImages = refImage
        config.maximumNumberOfTrackedImages = 1
        
        let options = ARSession.RunOptions([ARSession.RunOptions.removeExistingAnchors,
                       ARSession.RunOptions.resetTracking])
        
        sceneView.session.run(config, options: options)
        
    }
    
    @IBAction func reset(_ sender: UIButton) {
        resetTrackingConfig()
    }
}
