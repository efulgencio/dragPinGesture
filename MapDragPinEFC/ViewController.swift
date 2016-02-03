//
//  ViewController.swift
//  MapDragPinEFC
//
//  Created by eduardo fulgencio on 3/2/16.
//  Copyright © 2016 eduardo fulgencio. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate
{

    
    @IBOutlet weak var mapView: MKMapView!{
        didSet {
            mapView.mapType = .Standard
            mapView.delegate = self
        }
    }


    @IBAction func longPressAddPin(sender: AnyObject) {
        if sender.state == UIGestureRecognizerState.Began {
            let coordinate = mapView.convertPoint(sender.locationInView(mapView), toCoordinateFromView: mapView)
            let waypoint = EditableWaypoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
            waypoint.name = "Añadido pin"
            mapView.addAnnotation(waypoint)
        }
        
    }
    
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier(Constants.AnnotationViewReuseIdentifier)
        
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.AnnotationViewReuseIdentifier)
            view!.canShowCallout = false
        } else {
            view!.annotation = annotation
        }
        
        view!.draggable = annotation is EditableWaypoint
        
        view!.leftCalloutAccessoryView = nil
        view!.rightCalloutAccessoryView = nil
        
        if let waypoint = annotation as? GPX.Waypoint {
            if waypoint.thumbnailURL != nil {
                view!.leftCalloutAccessoryView = UIImageView(frame: Constants.LeftCalloutFrame)
            }
            if waypoint.imageURL != nil {
                view!.rightCalloutAccessoryView = UIButton.init(type:UIButtonType.DetailDisclosure) as UIButton
            }
        }
        
        return view
    }

    // MARK: - Constants
    
    private struct Constants {
        static let LeftCalloutFrame = CGRect(x: 0, y: 0, width: 59, height: 59)
        static let AnnotationViewReuseIdentifier = "waypoint"
    }

    
}

