//
//  ARViewController.swift
//  SampleAR
//
//  Created by Sayan Chatterjee on 20/05/20.
//  Copyright © 2020 Sayan Chatterjee. All rights reserved.
//

import Foundation
import UIKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    private let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUpSceneView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.sceneView.session.pause()
    }

    //MARK: - Setup Scene
    func setUpSceneView()  {
        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration)
        
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        self.sceneView.showsStatistics = true
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    //MARK: - ARSCNView Delegate
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
         // 1
         guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
         
         // 2
         let width = CGFloat(planeAnchor.extent.x)
         let height = CGFloat(planeAnchor.extent.z)
         let plane = SCNPlane(width: width, height: height)
         
         // 3
         plane.materials.first?.diffuse.contents = UIColor.blue
         
         // 4
         let planeNode = SCNNode(geometry: plane)
         
         // 5
         let x = CGFloat(planeAnchor.center.x)
         let y = CGFloat(planeAnchor.center.y)
         let z = CGFloat(planeAnchor.center.z)
         planeNode.position = SCNVector3(x,y,z)
         planeNode.eulerAngles.x = -.pi / 2
         
         // 6
         node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // 1
        guard let planeAnchor = anchor as?  ARPlaneAnchor,
        let planeNode = node.childNodes.first,
        let plane = planeNode.geometry as? SCNPlane
        else { return }
         
        // 2
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        plane.width = width
        plane.height = height
         
        // 3
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x, y, z)
    }
}

