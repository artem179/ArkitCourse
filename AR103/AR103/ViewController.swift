
import ARKit

extension ARController {
    
    func renderer(_ renderer: SCNSceneRenderer,
                 didAdd node: SCNNode,
                  for anchor: ARAnchor) {
        
        guard let imageAnchor = anchor as? ARImageAnchor,
              let imageName = imageAnchor.referenceImage.name
        else { return }

        // Add background thread for possibility to render without lagging
        DispatchQueue.global(qos: .background).async {
            let geometryNode = self.retrieveNode(name: imageName)
            geometryNode.opacity = 0
            geometryNode.runAction(self.fade)
            node.addChildNode(geometryNode)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    }
    
    func retrieveNode(name: String) -> SCNNode {
        
        var node = SCNNode()
        
        switch name {
            case "wateringcan": node = wateringCanNode
            case "retro_tv": node = tvRetroNode
            default: break
        }
        return node
    }
}


class ARController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    let fadeDuration: TimeInterval = 1.0
    let waitDuration: TimeInterval = 2.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        guard let refImage = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)
        else { return }
        
        let config = ARWorldTrackingConfiguration()
        config.detectionImages = refImage
        config.maximumNumberOfTrackedImages = 5
        
        sceneView.session.run(config, options: [ARSession.RunOptions.resetTracking,
             ARSession.RunOptions.removeExistingAnchors])
        
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    lazy var fade: SCNAction = {
        return SCNAction.sequence([
            SCNAction.fadeIn(duration: fadeDuration),
            SCNAction.wait(duration: 7.0),
            SCNAction.fadeOut(duration: fadeDuration)
        ])
    }()
    
    lazy var wateringCanNode: SCNNode = {
        
        guard let scene: SCNScene = SCNScene(named: "art.scnassets/wateringcan.usdz"),
              let node: SCNNode = scene.rootNode.childNode(withName: "wateringcan", recursively: true)
        else { return SCNNode() }
        
        let scaleFactor = 0.0025
        
        node.scale = SCNVector3(scaleFactor,
                                scaleFactor,
                                scaleFactor)
        
        node.eulerAngles.x = -Float.pi / 2
        
        return node
    }()
    
    lazy var tvRetroNode: SCNNode = {
        
        guard let scene: SCNScene = SCNScene(named: "art.scnassets/tv_retro.usdz"),
              let node: SCNNode = scene.rootNode.childNode(withName: "tv_retro", recursively: true)
        else { return SCNNode() }
        
        let scaleFactor = 0.0025
        
        node.scale = SCNVector3(scaleFactor,
                                scaleFactor,
                                scaleFactor)
        
        node.eulerAngles.x = -Float.pi / 2
        
        return node
    }()
}

