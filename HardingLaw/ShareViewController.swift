//
//  HowToUseAppViewController.swift
//  HardingLaw
//
//  Created by mobile developer on 2017. 02. 21..
//  Copyright © 2017. mobile developer. All rights reserved.
//

import Foundation

import UIKit

class ShareViewController: UIViewController {
    
    @IBOutlet var textView:UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = "Harding Law is the amazing app.\nPlease use this app.\nYou can download from https://itunes.apple.com/us/app/HardingLaw/id"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func displayShareSheet(shareContent:String) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func share() {
        displayShareSheet(shareContent:textView.text);
    }
    
    @IBAction func verdictsSettlements() {
        
        
    }
    
}
