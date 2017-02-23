//
//  FirstViewController.swift
//  HardingLaw
//
//  Created by mobile developer on 2017. 02. 19..
//  Copyright © 2017. mobile developer. All rights reserved.
//

import UIKit
import MessageUI

class ContactUsController: UIViewController, MFMailComposeViewControllerDelegate {

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
    
    @IBAction func emailUs() {
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.setToRecipients(["phil@hlaw.org"])
        composeVC.setSubject("")
        composeVC.setMessageBody("", isHTML: false)
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
}

