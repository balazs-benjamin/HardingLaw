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

class MessageViewController: UIViewController {
    var channelRef: FIRDatabaseReference!
    var channel: Channel? = nil
    var senderDisplayName: String = ""
    
    @IBOutlet var chatVc:ChatViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender:Any?)
    {
        if (segue.identifier == "myEmbeddedSegue") {
            chatVc = segue.destination as? ChatViewController
            
            chatVc.senderDisplayName = FIRAuth.auth()?.currentUser?.displayName
            
            let userDefaults = UserDefaults.standard
            let strChannelID = userDefaults.string(forKey: "channel")
            
            if channel == nil {
                channel = Channel(id: strChannelID!, name: (FIRAuth.auth()?.currentUser?.displayName)!)
                channelRef = FIRDatabase.database().reference().child("channels")
                senderDisplayName = (FIRAuth.auth()?.currentUser?.displayName)!

                chatVc.channelRef = channelRef.child((channel?.id)!)
            } else {
                chatVc.channelRef = self.channelRef
                senderDisplayName = "Attorney"
            }
            
            chatVc.channel = channel
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
}
