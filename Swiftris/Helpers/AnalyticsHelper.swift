//
//  AnalyticsHelper.swift
//  HuCaTetris
//
//  Created by HungNV on 9/8/17.
//  Copyright © 2017 HungNV. All rights reserved.
//

import UIKit
import FirebaseAnalytics

public let kAppName = "HuCaTetris"
public let TRACKING_ID = "UA-70915177-4"

class AnalyticsHelper: NSObject {
    static let shared = AnalyticsHelper()
    
    //MARK:- Google analytic
    func shareManage() {
        guard let gai = GAI.sharedInstance() else {
            assert(false, "Google Analytics not configured correctly")
            return
        }
        gai.trackUncaughtExceptions = true
        gai.dispatchInterval = 2
        gai.logger.logLevel = .none;
        gai.tracker(withName: kAppName, trackingId: TRACKING_ID)
    }
    
    func setGoogleAnalytic(name: String, value: String) {
        let tracker = GAI.sharedInstance().defaultTracker
        
        if (tracker == nil) {
            self.shareManage()
        } else {
            tracker?.set(name, value: value)
            let build = (GAIDictionaryBuilder.createScreenView().build() as NSDictionary) as! [AnyHashable: Any]
            tracker?.send(build)
        }
    }
    
    func sendGoogleAnalytic(category: String, action: String, label: String, value: NSNumber?) {
        let tracker = GAI.sharedInstance().defaultTracker
        
        if (tracker == nil) {
            self.shareManage()
        } else {
            guard let builder = GAIDictionaryBuilder.createEvent(withCategory: category, action: action, label: label, value: value) else { return }
            tracker?.send(builder.build() as [NSObject : AnyObject])
        }
    }
    
    //MARK:- Firebase analytic
    func setFirebaseAnalytic(screenName: String, screenClass: String) {
        Analytics.setScreenName(screenName, screenClass: screenClass)
    }
    
    func sendFirebaseAnalytic(event: String, category: String, action: String, label: String) {
        Analytics.logEvent(event, parameters: [
            "Category": category as NSObject,
            "Action": action as NSObject,
            "Label": label as NSObject
            ])
    }
}
