//
//  AppDelegate.swift
//  Notes
//
//  Created by Александр Андреев on 26/06/2019.
//  Copyright © 2019 Alexander Andreev. All rights reserved.
//

import UIKit
import CocoaLumberjack

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DDLog.add(DDOSLogger.sharedInstance)
        DDLogInfo("Notes App Started")
        
        let tabBarController = UITabBarController()
        let img = self.tabBarImage()
        
        let notesViewController = NotesViewController(nibName: nil, bundle: nil)
        let notesNavigationController = UINavigationController(rootViewController: notesViewController)
        notesNavigationController.tabBarItem = UITabBarItem(title: "Notes",
                                                            image: img,
                                                            selectedImage: nil)
        
        
        let galleryViewController = GalleryViewController(nibName: nil, bundle: nil)
        galleryViewController.tabBarItem = UITabBarItem(title: "Gallery",
                                                        image: img,
                                                        selectedImage: nil)
        
        tabBarController.viewControllers = [notesNavigationController,
                                            galleryViewController]
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    private func tabBarImage() -> UIImage {
        let size: CGFloat = 20.0
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        let img = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: size, height: size)
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fill)
        }
        
        return img
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

