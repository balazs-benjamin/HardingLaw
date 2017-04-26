//
//  MessageViewController.swift
//  HardingLaw
//
//  Created by mobile developer on 2017. 03. 06..
//  Copyright © 2017. mobile developer. All rights reserved.
//

import Foundation

import UIKit
import Firebase

class NotificationContainerViewController: UIViewController {
    var channelRef: FIRDatabaseReference!
    var channel: Channel? = nil
    var senderDisplayName: String = ""
    
    var isPushed = false
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet var bottomView:UIView?
    
    @IBOutlet var chatVc:NotificationsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: "isAdmin") {
            bottomView?.isHidden = true;
        } else {
            bottomView?.isHidden = false;
        }
        
        if(isPushed) {
            btnBack.addTarget(self, action: #selector(backPushed), for: .touchUpInside)
        }
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender:Any?)
    {
        if (segue.identifier == "myEmbeddedSegue") {
            chatVc = segue.destination as? NotificationsViewController
            
            chatVc.senderDisplayName = FIRAuth.auth()?.currentUser?.displayName
            
            channel = Channel(id: "notifications", name: "")
            chatVc.channel = channel

            channelRef = FIRDatabase.database().reference().child("notifications")
            chatVc.channelRef = channelRef
            
            senderDisplayName = chatVc.senderDisplayName
            chatVc.senderDisplayName = senderDisplayName
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func backPushed() {
        self.dismiss(animated: true, completion: nil)
    }

}
