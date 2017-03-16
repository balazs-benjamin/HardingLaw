//
//  AppDelegate.swift
//  HardingLaw
//
//  Created by mobile developer on 2017. 02. 19..
//  Copyright © 2017. mobile developer. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase
import OneSignal
import UserNotifications

enum UIUserInterfaceIdiom : Int {
    case unspecified
    
    case phone // iPhone and iPod touch style UI
    case pad // iPad style UI
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        sleep(0);
        
        GMSServices.provideAPIKey("AIzaSyAn049CvaRxsquyCgxVU7zM5YeQwIQH_Rs")
        GMSPlacesClient.provideAPIKey("AIzaSyAn049CvaRxsquyCgxVU7zM5YeQwIQH_Rs")
        
        FIRApp.configure()
        
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        //OneSignal.registerForPushNotifications()
        
        var isAdmin = false
        
        if let userID = FIRAuth.auth()?.currentUser?.uid {
            FIRDatabase.database().reference().child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                isAdmin = value?["isAdmin"] as? Bool ?? false
                UserDefaults.standard.set(isAdmin, forKey: "isAdmin")
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
        
        OneSignal.initWithLaunchOptions(launchOptions, appId: "0a0cf4e9-5278-4f12-aa91-9611e0f9337a", handleNotificationReceived: { (notification) in
            print("Received Notification - \(notification?.payload.notificationID)")
        }, handleNotificationAction: { (result) in
            
            let payload: OSNotificationPayload? = result?.notification.payload
            
            var fullMessage: String? = payload?.body
            if payload?.additionalData != nil {
                var additionalData: [AnyHashable: Any]? = payload?.additionalData
                if additionalData!["actionSelected"] != nil {
                    fullMessage = fullMessage! + "\nPressed ButtonId:\(additionalData!["actionSelected"])"
                }
            }
            
            print(fullMessage ?? "")

        }, settings: [kOSSettingsKeyAutoPrompt : true, kOSSettingsKeyInAppAlerts : false])
        
        OneSignal.idsAvailable({ (userId, pushToken) in
            print("UserId:%@", userId!);
            if (pushToken != nil) {
                NSLog("Sending Test Noification to this device now");
                //OneSignal.postNotification(["contents": ["en": "Test Message"], "include_player_ids": [userId]]);
                
                UserDefaults.standard.set(userId, forKey: "OneSignalId")
                
                if FIRAuth.auth()?.currentUser != nil {
                    let uid = FIRAuth.auth()?.currentUser!.uid
                    let ref = FIRDatabase.database().reference().child("users/\(uid!)/OneSignalId")
                    ref.setValue(userId!)
                }
            }
        })
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main);
        
        let userDefaults = UserDefaults.standard
        if userDefaults.string(forKey: "userid") != nil {
            if userDefaults.bool(forKey: "isAdmin") || isAdmin {
                self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "AdminHomeViewController");
                //self.performSegue(withIdentifier: "AdminLogin", sender: nil)
                
            } else {
                self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "UserHomeViewController");
                //self.performSegue(withIdentifier: "UserLogin", sender: nil)
            }
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
