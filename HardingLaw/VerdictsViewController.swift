//
//  SecondViewController.swift
//  HardingLaw
//
//  Created by mobile developer on 2017. 02. 19..
//  Copyright © 2017. mobile developer. All rights reserved.
//

import UIKit

class VerdictsViewController: UIViewController {
    
    @IBOutlet var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //webView.loadRequest(URLRequest(url: URL(string:  "http://www.hlaw.org/verdictsAndSettlements.asp")!))
        let urlView = Bundle.main.url(forResource: "verdicts", withExtension: "html")
        webView.loadRequest(URLRequest(url: urlView!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func back() {
        _ = navigationController?.popViewController(animated: true)
    }
}

