//
//  FirstViewController.swift
//  HardingLaw
//
//  Created by mobile developer on 2017. 02. 19..
//  Copyright © 2017. mobile developer. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }

    @IBAction func visit() {
        open(scheme:"http://profiles.superlawyers.com/colorado/denver/lawyer/phil-harding/a2b8f642-600e-4199-8575-f1c184244489.html")
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
    
    @IBAction func verdictsSettlements() {
        
        
    }
    
    
    
}

