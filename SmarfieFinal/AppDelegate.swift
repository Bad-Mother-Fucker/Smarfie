//
//  AppDelegate.swift
//  SmarfieFinal
//
//  Created by UMBERTO GRIMALDI on 21/02/2018.
//  Copyright © 2018 UMBERTO GRIMALDI. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let isFirstLaunch = UserDefaults.standard.isFirstLaunch
    var window: UIWindow?
    var viewController:UIViewController!
    let fetchRequest: NSFetchRequest<BestPhotos> = BestPhotos.fetchRequest()
    let fetchRequestFav:NSFetchRequest<FavouritesPhotos> = FavouritesPhotos.fetchRequest()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        DispatchQueue.main.async {
            BestSelfie.shared.retrieveBest()
            BestSelfie.shared.retrieveFav()
            NotificationCenter.default.post(Notification(name: Notification.Name("ReloadCollectionViews")))
        }
        
        if isFirstLaunch{
            viewController = UIStoryboard(name: "OnBoarding", bundle: nil).instantiateInitialViewController()
        }else{
            viewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        }
     
        window?.rootViewController = viewController


        
        
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
        PersistenceService.saveContext()
    }

}

extension UserDefaults{
    var isFirstLaunch:Bool{
        get{
            let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
            let  firstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
            if firstLaunch{
                UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
                UserDefaults.standard.synchronize()
            }
            return firstLaunch
        }
    }
}

