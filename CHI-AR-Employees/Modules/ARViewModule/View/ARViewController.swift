//
//  ViewController.swift
//  CHI-AR-Employees
//
//  Created by user on 12/24/18.
//  Copyright © 2018 Vitaliy Manov. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {

    //MARK: - outlets
    @IBOutlet var sceneView: ARSCNView!
    
    //MARK: - properties
    var user = User()
    private var arViewModel: ARViewModel = ARViewModel() 
    
    //MARK: - view controller's life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSceneView()
        //test database
//        Database.database().reference().child("newKey").updateChildValues(["a": "b"])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    private func setupSceneView() {
        sceneView.delegate = self
        let scene = SCNScene()
        sceneView.scene = scene
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
