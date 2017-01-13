//
//  ViewController.swift
//  MyPlaces
//
//  Created by spencerdezartsmith on 1/13/17.
//  Copyright © 2017 spencerdezartsmith. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if activePlace != -1 {
            
            // Get details for chosen place to display on the map
            
            if places.count > activePlace {
               
                if let name = places[activePlace]["name"] {
                    
                    if let lat = places[activePlace]["lat"] {
                        
                        if let lon = places[activePlace]["lon"] {
                            
                            let latitude: CLLocationDegrees = Double(lat)!
                            
                            let longitude: CLLocationDegrees = Double(lon)!
                            
                            let latDelta: CLLocationDegrees = 0.03
                            
                            let lonDelta: CLLocationDegrees = 0.03
                            
                            let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
                            
                            let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                            
                            let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
                            
                            map.setRegion(region, animated: true)
                            
                            let annotation = MKPointAnnotation()
                            
                            annotation.title = name
                            
                            annotation.coordinate = location
                            
                            map.addAnnotation(annotation)
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

