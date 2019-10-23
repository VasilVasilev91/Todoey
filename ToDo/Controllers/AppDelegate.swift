//
//  AppDelegate.swift
//  ToDo
//
//  Created by Vasil Vasilev on 17.10.19.
//  Copyright © 2019 Vasil Vasilev. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



       func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        print(Realm.Configuration.defaultConfiguration.fileURL)
            
        
        do {
            _ = try Realm()
        } catch {
            print("Error initialising realm: \(error)")
        }
        
        
            
            return true
        }

    }

