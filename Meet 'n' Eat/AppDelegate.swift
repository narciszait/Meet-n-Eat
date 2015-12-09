//
//  AppDelegate.swift
//  Meet 'n' Eat
//
//  Created by Narcis Zait on 26/10/15.
//  Copyright © 2015 Narcis Zait. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit
import Parse
import ParseFacebookUtilsV4

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let defaults = NSUserDefaults.standardUserDefaults()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
//        application.setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true);
        
//        if defaults.valueForKey("FBLoggedIn") != nil {
//            print("FBLoggedIn exists");
//            let storyboard = UIStoryboard(name: "Main", bundle: nil);
//            self.window?.rootViewController = storyboard.instantiateViewControllerWithIdentifier("Success") as? SuccessViewController
//        }

       // let isFacebookAuthorized = application.canOpenURL(NSURL(fileURLWithPath: "fbauth://authorize"));
        Parse.setApplicationId("gTcnz8TitnGTLPRhEmKc9LdLNucARollwYNmFqXw", clientKey: "96obICPl32RPIc5LJJcEkBySpTup6mT87BzvVlt6");
        
        
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions);
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions);
        application.statusBarStyle = .LightContent;
        
//        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil);
//        application.registerUserNotificationSettings(settings);
//        application.registerForRemoteNotifications();
        
        // Register for Push Notitications
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus");
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:");
            var pushPayload = false;
            if let options = launchOptions {
                pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil;
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions);
            }
        }
        if application.respondsToSelector("registerUserNotificationSettings:") {
            //let userNotificationTypes: UIUserNotificationSettings = [.Alert, .Badge, .Sound];
            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil);
            application.registerUserNotificationSettings(settings);
            application.registerForRemoteNotifications();
        }
//        } else {
////            let types: UIRemoteNotificationType = UIRemoteNotificationType()
//            let types = [UIRemoteNotificationType.Badge, UIRemoteNotificationType.Alert, UIRemoteNotificationType.Sound];
//            application.registerForRemoteNotificationTypes(types)
//        }

        return true // FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions) //
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let currentInstallation: PFInstallation = PFInstallation.currentInstallation();
        currentInstallation.setDeviceTokenFromData(deviceToken);
        //currentInstallation.channels = ["global"];
        currentInstallation.saveInBackground();
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.");
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo);
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo);
        }
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation);
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp();
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

