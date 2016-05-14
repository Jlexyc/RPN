//
//  AppDelegate.swift
//  RPN
//
//  Created by Oleksii Kozulin on 5/7/16.
//  Copyright © 2016 Oleksii Kozulin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        application.applicationIconBadgeNumber = 0;
//        let notificationSettings = UIUserNotificationSettings(forTypes:[.Alert,.Badge,.Sound], categories: nil)
//        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)

        return true
    }

    func application(application: UIApplication,
                       performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        let notification = UILocalNotification()
        let date = NSDate(timeIntervalSinceNow: 0)
        notification.fireDate = date;
        notification.alertBody = "I'm a notification"
        application.scheduleLocalNotification(notification)
        application.applicationIconBadgeNumber = 10;
        Networking().updateInformation(DataController().managedObjectContext)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
//        let notification = UILocalNotification()
//        let date = NSDate(timeIntervalSinceNow: 10)
//        notification.fireDate = date;
//        notification.alertBody = "I'm a notification"
//        application.scheduleLocalNotification(notification)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, completionHandler: (UIBackgroundFetchResult) -> Void) {
            print("I was called")
    }
}



//application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))
//let notification = UILocalNotification()
//notification.alertBody = "Hello! Man!"
//notification.alertAction = "open"
//notification.fireDate = NSDate(timeInterval: 20, sinceDate: NSDate())
//notification.soundName = UILocalNotificationDefaultSoundName
//notification.userInfo = ["UUID": "Unique", ]
//notification.category = "TODO_CATEGORY"
//UIApplication.sharedApplication().scheduleLocalNotification(notification)
