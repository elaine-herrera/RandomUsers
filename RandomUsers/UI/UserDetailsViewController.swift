//
//  UserDetailsViewController.swift
//  RandomUsers
//
//  Created by Elaine Herrera on 26/5/22.
//

import Foundation
import UIKit
import MapKit

class UserDetailsViewController: UIViewController{
    
    var user: User?
    let reuseIdentifier = "MKMarkerAnnotationView"
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: reuseIdentifier)
        return map
    }()
    
    let regionInMeter: Double = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        addUserLocationInMap()
        setUpNavBar()
    }
    
    func setUpView(){
        view.addSubview(mapView)
        let mapConstraints = [
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        NSLayoutConstraint.activate(mapConstraints)
    }
    
    func addUserLocationInMap(){
        if let location = user?.location {
            guard let latitude = location.coordinates?.latitude, let longitude = location.coordinates?.longitude else { return }
            
            let annotation = UserAnnotation(coordinate: CLLocationCoordinate2D(latitude: Double(latitude) ?? 0.0, longitude: Double(longitude) ?? 0.0))
            annotation.title = user?.fullName()
            annotation.subtitle = user?.location?.country
            mapView.addAnnotations([annotation])
            let center = CLLocationCoordinate2D(latitude: Double(latitude) ?? 0.0, longitude: Double(longitude) ?? 0.0)
            let region = MKCoordinateRegion(center: center, latitudinalMeters: regionInMeter, longitudinalMeters: regionInMeter)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func setUpNavBar(){
        let closeBtn = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(close))
        closeBtn.accessibilityLabel = "Close Button"
        navigationItem.rightBarButtonItem = closeBtn
    }
    
    @objc func close(){
        dismiss(animated: true)
    }
}

extension UserDetailsViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: annotation)
        
        if let markerAnnotationView = annotationView as? MKMarkerAnnotationView {
            markerAnnotationView.animatesWhenAdded = true
            markerAnnotationView.canShowCallout = true
            markerAnnotationView.markerTintColor = UIColor.red
            markerAnnotationView.detailCalloutAccessoryView = UIImageView(image: UIImage(systemName: "map"))
        }
        return annotationView
    }
}
