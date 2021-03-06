//
//  AppDelegate.swift
//  MoltinSwiftExample
//
//  Created by Kelin Christi on 26/01/2016.
//  Copyright (c) 2016 Kelz All rights reserved.
//

import Foundation
import UIKit
import Moltin
import UberRides
import HexColors

// Declare some global constants to make them easily accessible in other classes.

let BASE_URL = "https://zest-kelin-christi.firebaseio.com"

let MOLTIN_STORE_ID = "aqA2mV2YKWpmu4daVS7Fh2WbWLH0xe1f2i9hHrkR"

let MOLTIN_LOGGING = true

// RGB: 139, 98, 181

let MOLTIN_COLOR = UIColor.hx_colorWithHexString("#43C59E")

//(red: (139.0/255.0), green: (98.0/255.0), blue: (181.0/255.0), alpha: 1.0)


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // Set the window's tint color to the Moltin color
        
        //Uber Client
//        RidesClient.sharedInstance.configureClientID("Wzsftom7_G7l18wTT-asWUDzsyR3IlkG")
        
        self.window?.tintColor = MOLTIN_COLOR
        
        // Initialise the Moltin SDK with our store ID.
        Moltin.sharedInstance().setPublicId(MOLTIN_STORE_ID)
        
        // Do you want the Moltin SDK to log API calls? (This should probably be false in production apps...)
        Moltin.sharedInstance().setLoggingEnabled(MOLTIN_LOGGING)
        
        
        return true
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
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func switchToCartTab() {
        let tabBarController = self.window!.rootViewController as! UITabBarController
        tabBarController.selectedIndex = 1
        
    }


}

