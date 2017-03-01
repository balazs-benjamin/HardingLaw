//
//  HowToUseAppViewController.swift
//  HardingLaw
//
//  Created by mobile developer on 2017. 02. 21..
//  Copyright © 2017. mobile developer. All rights reserved.
//

import Foundation

import UIKit


import GoogleMaps
import CoreLocation
import Alamofire


class NearbyMapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var mapView:GMSMapView!
    @IBOutlet var titleLabel:UILabel!
    var locationManager = CLLocationManager()
    var lat = 39.746478
    var long = -104.991775
    var radius = 5000
    var APIKey = "AIzaSyDfFAcntiyqlGhxK8siXHgxnPYM4UIzOVk"
    var type = ""
    var bFirstLoad = true
    var titleString: String = ""
    
    var bounds = GMSCoordinateBounds()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        titleLabel.text = titleString
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        long = userLocation.coordinate.longitude;
        lat = userLocation.coordinate.latitude;
        
        if !bFirstLoad{
            return
        }
        bFirstLoad = false
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 13.0)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.title = ""
        marker.snippet = ""
        marker.map = mapView
        
        bounds = bounds.includingCoordinate(marker.position)
        
        getData()
        
        print(long, lat)
        
        //Do What ever you want with it
    }
    
    func getData() {
        var url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(long)&type=\(type)&key=\(APIKey)&rankby=distance"
        if type == "tow_truck" {
            url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(long)&keyword=tow+truck&key=\(APIKey)&rankby=distance"
        }
        Alamofire.request(url).responseJSON { response in
            debugPrint(response)
            
            if let json = response.result.value {
                print("JSON: \(json)")
                
                var names = [String]()
                var lats = [Double]()
                var longs = [Double]()
                var vicinitys = [String]()

                let jsonResult = json as! [String : AnyObject]
                if let results = jsonResult["results"] as? [[String : AnyObject]] {
                    for result in results{
                        if let name = result["name"] as? String {
                            names.append(name)
                        }
                        if let vicinity = result["vicinity"] as? String {
                            vicinitys.append(vicinity)
                        }
                        if let geometry = result["geometry"] as? [String : AnyObject] {
                            if let location = geometry["location"] as? [String : AnyObject] {
                                if let lat = location["lat"] as? Double {
                                    lats.append(lat)
                                }
                                if let long = location["lng"] as? Double {
                                    longs.append(long)
                                }
                            }
                        }
                    }
                }
                
                
                print(names)
                print(vicinitys)
                print(lats)
                print(longs)
                
                if names.count > 0 {
                    
                    for i in 0...names.count-1 {
                        let marker = GMSMarker()
                        marker.position = CLLocationCoordinate2D(latitude: lats[i], longitude: longs[i])
                        marker.title = names[i]
                        marker.snippet = vicinitys[i]
                        marker.icon = GMSMarker.markerImage(with: UIColor.green)
                        marker.map = self.mapView
                        marker.opacity = 0.85
                        marker.isFlat = true
                        marker.appearAnimation = GMSMarkerAnimation.pop
                        
                        if self.mapView.selectedMarker == nil {
                            self.mapView.selectedMarker = marker
                        }
                        self.bounds = self.bounds.includingCoordinate(marker.position)
                    }
                    
                    let update = GMSCameraUpdate.fit(self.bounds, withPadding: 100)
                    self.mapView.animate(with: update)
                }
            }
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back() {
        _ = navigationController?.popViewController(animated: true)
    }
        
}
