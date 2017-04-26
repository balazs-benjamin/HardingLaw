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
    
    
    var isPushed = false
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet var chatVc:ChatViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if(isPushed) {
            btnBack.addTarget(self, action: #selector(backPushed), for: .touchUpInside)
        }
        
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender:Any?)
    {
        if (segue.identifier == "myEmbeddedSegue") {
            chatVc = segue.destination as? ChatViewController
            
            chatVc.senderDisplayName = FIRAuth.auth()?.currentUser?.displayName
            
            let userDefaults = UserDefaults.standard
            let strChannelID = userDefaults.string(forKey: "channel")
            let sender_name = userDefaults.string(forKey: "user_name")
            
            if channel == nil {
                channel = Channel(id: strChannelID!, name: (FIRAuth.auth()?.currentUser?.displayName)!)
                channelRef = FIRDatabase.database().reference().child("channels")
                senderDisplayName = sender_name!

                chatVc.channelRef = channelRef.child((channel?.id)!)
            } else {
                chatVc.channelRef = self.channelRef
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
    
    @IBAction func backPushed() {
        self.dismiss(animated: true, completion: nil)
    }
}
