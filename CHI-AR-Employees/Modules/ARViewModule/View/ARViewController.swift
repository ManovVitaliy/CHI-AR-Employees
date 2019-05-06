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
import RxSwift
import CoreLocation

class ARViewController: UIViewController {

    //MARK: - outlets
    @IBOutlet var sceneView: ARSCNView!
    
    let sceneLocationView = SceneLocationView()
    
    //MARK: - properties
    var user = User()
    private let disposeBag = DisposeBag()
    private var arViewModel: ARViewModel = ARViewModel() 
    
    //MARK: - view controller's life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupSceneView()
        //test database
//        Database.database().reference().child("newKey").updateChildValues(["a": "b"])
        setupObservableValues()
        
        sceneLocationView.locationDelegate = self
        
        sceneLocationView.locationManager.delegate = self
        
        sceneLocationView.delegate = self
        
        buildDemoData().forEach { sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: $0) }
        
        view.addSubview(sceneLocationView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneLocationView.run()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneLocationView.pause()
    }
    
    // observable values
    private func setupObservableValues() {
        observeCurrentPosition()
        observeNodes()
    }
    
    private func observeCurrentPosition() {
        arViewModel.currentPosition.asObservable()
                .subscribe { (newVector) in
                    print(newVector)
                }
                .disposed(by: disposeBag)
    }
    
    private func observeNodes() {
        arViewModel.myNodes.asObservable()
                .subscribe { (nodes) in
                    if let nodes = nodes.element {
                        var myNodes: [LocationAnnotationNode] = []
                        for node in nodes {
                            let myState = self.buildNode(latitude: Double(node.position.x),
                                                    longitude: Double(node.position.z),
                                                    altitude: Double(node.position.y),
                                                    imageName: "CHI-logo")
                            myNodes.append(myState)
                        }
                        myNodes.forEach { self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: $0) }
                    }
                }
                .disposed(by: disposeBag)
        
    }
}

// MARK: - SceneLocationViewDelegate
@available(iOS 11.0, *)
extension ARViewController: SceneLocationViewDelegate {
    func sceneLocationViewDidAddSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        print("add scene location estimate, position: \(position), location: \(location.coordinate), accuracy: \(location.horizontalAccuracy), date: \(location.timestamp)")
    }
    
    func sceneLocationViewDidRemoveSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        print("remove scene location estimate, position: \(position), location: \(location.coordinate), accuracy: \(location.horizontalAccuracy), date: \(location.timestamp)")
    }
    
    func sceneLocationViewDidConfirmLocationOfNode(sceneLocationView: SceneLocationView, node: LocationNode) {
    }
    
    func sceneLocationViewDidSetupSceneNode(sceneLocationView: SceneLocationView, sceneNode: SCNNode) {
        
    }
    
    func sceneLocationViewDidUpdateLocationAndScaleOfLocationNode(sceneLocationView: SceneLocationView, locationNode: LocationNode) {
        
    }
}

// MARK: - Data Helpers
@available(iOS 11.0, *)
private extension ARViewController {
    func buildDemoData() -> [LocationAnnotationNode] {
        var nodes: [LocationAnnotationNode] = []
        
        let myState = buildNode(latitude: 50.4492138572848, longitude: 30.513757292626497, altitude: 149.4332381596928, imageName: "CHI-logo")
        nodes.append(myState)
        
        return nodes
    }
    
    func buildNode(latitude: CLLocationDegrees, longitude: CLLocationDegrees, altitude: CLLocationDistance, imageName: String) -> LocationAnnotationNode {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let location = CLLocation(coordinate: coordinate, altitude: altitude)
        let image = UIImage(named: imageName)!
        return LocationAnnotationNode(location: location, image: image)
    }
}

extension DispatchQueue {
    func asyncAfter(timeInterval: TimeInterval, execute: @escaping () -> Void) {
        self.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(timeInterval * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: execute)
    }
}

extension UIView {
    func recursiveSubviews() -> [UIView] {
        var recursiveSubviews = self.subviews
        
        for subview in subviews {
            recursiveSubviews.append(contentsOf: subview.recursiveSubviews())
        }
        
        return recursiveSubviews
    }
}

// MARK: - LocationManager
@available(iOS 11.0, *)
extension ARViewController: LocationManagerDelegate {
    func locationManagerDidUpdateLocation(_ locationManager: LocationManager, location: CLLocation) {
        sceneLocationView.addSceneLocationEstimate(location: location)
    }
    
    func locationManagerDidUpdateHeading(_ locationManager: LocationManager, heading: CLLocationDirection, accuracy: CLLocationAccuracy) {
        // negative value means the heading will equal the `magneticHeading`, and we're interested in the `trueHeading`
        if accuracy < 0 {
            return
        }
        // heading of 0º means its pointing to the geographic North
        if heading == 0 {
            sceneLocationView.resetSceneHeading()
        }
    }
}

extension ARViewController: ARSCNViewDelegate {
    // MARK: - ARSCNViewDelegate
    
    public func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        if sceneLocationView.sceneNode == nil {
            sceneLocationView.sceneNode = SCNNode()
            sceneLocationView.scene.rootNode.addChildNode(sceneLocationView.sceneNode!)
        }
        
        if !sceneLocationView.didFetchInitialLocation {
            //Current frame and current location are required for this to be successful
            if sceneLocationView.session.currentFrame != nil,
                let currentLocation = sceneLocationView.locationManager.currentLocation {
                sceneLocationView.didFetchInitialLocation = true
                
                if let curLocation = sceneLocationView.currentLocation() {
                    sceneLocationView.addSceneLocationEstimate(location: curLocation)
                }
            }
        }
    }
}
