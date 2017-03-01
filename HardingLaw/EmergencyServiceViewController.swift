//
//  HowToUseAppViewController.swift
//  HardingLaw
//
//  Created by mobile developer on 2017. 02. 21..
//  Copyright © 2017. mobile developer. All rights reserved.
//

import Foundation

import UIKit
import Alamofire

class EmergencyServiceViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func goto(type: String, title:String) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "nearbyVC") as! NearbyMapViewController
        myVC.type = type
        myVC.titleString = title
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    @IBAction func findPoliceStation() {
       goto(type: "police", title: "Find a Police Station")
    }
    
    @IBAction func findHospital() {
        goto(type: "hospital", title: "Find Hospital Nearby")
        
    }

    @IBAction func findTaxi() {
        goto(type: "taxi_stand", title: "Find A Taxi")
        
    }

    @IBAction func findRepairShop() {
        goto(type: "car_repair", title: "Find Auto Repair Shop")
        
    }
    
    @IBAction func findTowTruck() {
        goto(type: "tow_truck", title: "Find A Tow-Truck")
        
    }
    
    func open(scheme: String) {
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            print("Open \(scheme): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(scheme): \(success)")
            }
        }
    }
    
    @IBAction func callPhil() {
        if let url = URL(string: "tel://13037629500") , UIApplication.shared.canOpenURL(url) {
            open(scheme:"tel://13037629500")
        }
    }

}
