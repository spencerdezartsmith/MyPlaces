//
//  ViewController.swift
//  MyPlaces
//
//  Created by spencerdezartsmith on 1/13/17.
//  Copyright © 2017 spencerdezartsmith. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet var map: MKMapView!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longpress(gestureRecognizer:)))
        
        longPressRecognizer.minimumPressDuration = 2
        
        map.addGestureRecognizer(longPressRecognizer)
        
        if activePlace == -1 {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            
        } else {
        
            // Get details for chosen place to display on the map
            
            if places.count > activePlace {
               
                if let name = places[activePlace]["name"] {
                    
                    if let lat = places[activePlace]["lat"] {
                        
                        if let lon = places[activePlace]["lon"] {
                            
                            if let latitude: CLLocationDegrees = Double(lat) {
                            
                                if let longitude: CLLocationDegrees = Double(lon) {
                                
                                    let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
                                    
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
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        self.map.setRegion(region, animated: true)
        
    }
    
    func longpress(gestureRecognizer: UIGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizerState.began {
        
            let touchPoint = gestureRecognizer.location(in: self.map)
            
            let newCoodinate = self.map.convert(touchPoint, toCoordinateFrom: self.map)
            
            let newLocation: CLLocation = CLLocation(latitude: newCoodinate.latitude, longitude: newCoodinate.longitude)
            
            var title = ""
            
            CLGeocoder().reverseGeocodeLocation(newLocation, completionHandler: { (placemarks, error) in
            
                if error != nil {
                    
                    print(error)
                    
                } else {
                    
                    if let placemark = placemarks?[0] {
                        
                        if placemark.subThoroughfare != nil {
                            
                            title += placemark.subThoroughfare! + " "
                            
                        }
                        
                        if placemark.thoroughfare != nil {
                            
                            title += placemark.thoroughfare!
                        }
                    }
                }
                
                if title == "" {
                    
                    title = "Added \(NSDate())"
                    
                }
                
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = newCoodinate
                
                annotation.title = title
                
                self.map.addAnnotation(annotation)
                
                places.append(["name": title, "lat": "\(newCoodinate.latitude)", "lon": "\(newCoodinate.longitude)"])
                
                UserDefaults.standard.set(places, forKey: "places")
                
            
            })
            
          
            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

