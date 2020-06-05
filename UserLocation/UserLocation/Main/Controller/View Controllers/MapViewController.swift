//
//  MapViewController.swift
//  UserLocation
//
//  Created by Kenny on 6/4/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!

    let timelines = [
        Timeline(),
        Timeline(),
        Timeline()
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.register(
            MKMarkerAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: "TimelineView"
        )
        guard let timelines = timelines as? [MKAnnotation] else { return }
        mapView.addAnnotations(timelines)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let timeline = annotation as? Timeline else {
            fatalError("Only timeline objects are supported")
        }


        //TODO: Set Image
        guard let markerAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: "TimelineView", for: timeline as! MKAnnotation) as? MKMarkerAnnotationView else {
            fatalError("Unsupported Annotation Type. Register a map annotation view")
        }

        markerAnnotation.markerTintColor = .cyan

        markerAnnotation.canShowCallout = true
        //TODO: Setup Detail View
        //let detailView = TimelineDetailView()
        return markerAnnotation
    }
}
