//
//  AppDelegate.swift
//  HuCaTetris
//
//  Created by HungNV on 6/23/17.
//  Copyright © 2017 HungNV. All rights reserved.
//

import UIKit
import UserNotifications

public let kUserDefault = "kUserDefault_Push_FirsTime"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GoogleAdMobHelper.shared.initializeBannerView(isLiveUnitID: true)
        GoogleAdMobHelper.shared.initializeInterstitial(isLiveUnitID: true)
        AnalyticsHelper.shared.shareManage()
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:  [.alert, .sound, .badge])
            { (success, error) in
                if success {
                    //print("Permission Granted")
                } else {
                    //print("There was a problem!")
                }
            }
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        if UserDefaults.standard.object(forKey: kUserDefault) == nil {
            self.setupLocalPushFirstTime()
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if UserDefaults.standard.object(forKey: kUserDefault) != nil {
            UserDefaults.standard.removeObject(forKey: kUserDefault)
            application.cancelAllLocalNotifications()
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

//MARK:- Create push notification
extension AppDelegate {
    @available(iOS 10.0, *)
    func requestNotification(application: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (permissionGranted, error) in
        })
    }
    
    func setupLocalPushFirstTime() {
        var date = DateComponents()
        date.hour = 17
        date.minute = 30
        UserDefaults.standard.set("vFirstTime", forKey: kUserDefault)
        
        if #available(iOS 10.0, *) {
            let notification = UNMutableNotificationContent()
            notification.body = "Are you there today's play game?\nLet's play now!"
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
            let request = UNNotificationRequest(identifier: "kFirstTime", content: notification, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
}
