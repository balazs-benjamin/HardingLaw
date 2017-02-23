//
//  HowToUseAppViewController.swift
//  HardingLaw
//
//  Created by mobile developer on 2017. 02. 21..
//  Copyright © 2017. mobile developer. All rights reserved.
//

import Foundation

import UIKit

class AttorneyLocationViewController: UIViewController {
    
    @IBOutlet var textView:UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @IBAction func verdictsSettlements() {
        
        
    }
    
}
