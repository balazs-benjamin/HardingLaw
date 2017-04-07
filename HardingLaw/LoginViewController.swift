//
//  FirstViewController.swift
//  HardingLaw
//
//  Created by mobile developer on 2017. 02. 19..
//  Copyright © 2017. mobile developer. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet var nameField:UITextField!
    private lazy var channelRef: FIRDatabaseReference = FIRDatabase.database().reference().child("channels")

    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.attributedPlaceholder = NSAttributedString(string: "Your Name",
                                                             attributes: [NSForegroundColorAttributeName: UIColor.white])

        
        /*
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                let ref = FIRDatabase.database().reference().child("users").child(user!.uid)
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.hasChildren(){
                        if snapshot.childSnapshot(forPath: "name").value as! String == "admin" {
                            self.performSegue(withIdentifier: "AdminLogin", sender: nil)
                        } else {
                            self.performSegue(withIdentifier: "UserLogin", sender: nil)
                        }
                    }
                })
            }
        }
 */
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AdminLogin" {
            super.prepare(for: segue, sender: sender)
            //let navVc = segue.destination as! UINavigationController
            //let channelVc = navVc.viewControllers.first as! ChannelListViewController
            
            //channelVc.senderDisplayName = nameField?.text
        } else if segue.identifier == "UserLogin" {
            super.prepare(for: segue, sender: sender)
            
            
        }
    }


    @IBAction func login() {
        if nameField?.text != "" {
            FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
                if let err:Error = error {
                    print(err.localizedDescription)
                    return
                }
                
                let changeRequest = user!.profileChangeRequest()
                changeRequest.displayName = self.nameField.text!
                changeRequest.commitChanges { error in
                    if error != nil {
                        // An error happened.
                    } else {
                        // Profile updated.
                    }
                }
                
                let ref = FIRDatabase.database().reference().child("users").child(user!.uid)
                var oneSignalId = UserDefaults.standard.string(forKey: "OneSignalId")
                if oneSignalId == nil { oneSignalId = ""}
                let newUser = [
                    "isAdmin": false,
                    "name":self.nameField.text!,
                    "OneSignalId": oneSignalId! as String
                    ] as [String : Any]
                ref.setValue(newUser)

                self.createChannel(id: user!.uid, name: self.nameField.text!)
                
                let userDefaults = UserDefaults.standard
                userDefaults.set(user!.uid, forKey: "userid")
                userDefaults.set(self.nameField.text!, forKey: "user_name")
                userDefaults.synchronize()
                
                let IamAdmin = UserDefaults.standard.bool(forKey: "isAdmin")
                if IamAdmin {
                    self.performSegue(withIdentifier: "AdminLogin", sender: nil)
                } else {
                    self.performSegue(withIdentifier: "UserLogin", sender: nil)
                }               

            })
        } else {
            let alertController = UIAlertController(title: "Error", message: "Please enter your name.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
    }

    
    func createChannel(id:String, name: String) {
        let newChannelRef = channelRef.child(id)
        let channelItem = [
            "name": name
        ]
        newChannelRef.setValue(channelItem)

        let userDefaults = UserDefaults.standard
        userDefaults.set(newChannelRef.key, forKey: "channel")
        userDefaults.synchronize()
    }
    
    
}

