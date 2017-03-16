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
import GooglePlacePicker


class LocationPickerViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var mapView:GMSMapView!
    var locationManager = CLLocationManager()
    var lat = 39.746478
    var long = -104.991775
    var bFirstLoad = true
    
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
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        long = userLocation.coordinate.longitude;
        lat = userLocation.coordinate.latitude;
        
        if !bFirstLoad{
            return
        }
        bFirstLoad = false
        
        let config : GMSPlacePickerConfig = GMSPlacePickerConfig(viewport:nil)
        let placePicker : GMSPlacePicker = GMSPlacePicker(config: config)
        
        placePicker.pickPlace(){
            (gmsPlace, error) -> Void in
            if let error = error{
                print("error:\(error)")
            }else{
                if let gmsPlace = gmsPlace{
                    if let formattedAddress = gmsPlace.formattedAddress{
                        print("formattedAddress:\r\(formattedAddress)")
                    }else{
                        print("gmsPlace.formattedAddress is nil")
                    }
                    
                }else{
                    print("gmsPlace is nil")
                }
                
                print("info")
            }
        }

        
        //Do What ever you want with it
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
    
    @IBAction func buttonPlacesPicker_TouchUpInside(sender: AnyObject) {
    }
    
}
