//
//  MapView.swift
//  VisitCard
//
//  Created by Damien DELES on 19/03/2021.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    // MARK: - Binding
    @Binding var coordinate: CLLocationCoordinate2D
    
    // MARK: - Functions
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
       // Do nothing
    }
    
    func makeUIView(context: Context) -> some UIView {
        let mapView = MKMapView()
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "My location"
        mapView.addAnnotation(annotation)
        
        let diameter = 0.3 * 2000
        let region: MKCoordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: diameter, longitudinalMeters: diameter)
        mapView.setRegion(region, animated: false)
        
        return mapView
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(parent: MapView) {
            self.parent = parent
        }
    }
}
