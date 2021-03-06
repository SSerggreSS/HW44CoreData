//
//  AppDelegate.swift
//  HW44CoreData
//
//  Created by Сергей on 19.05.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //uncomment the code for add objects in database
/*
        let students = DataManager.sharedManager.addRandomStudentsTest(amount: 10)
        let coursesOfStudent = DataManager.sharedManager.addCourses()
        DataManager.sharedManager.addRandomTeachers(amount: 10)
        for student in students {

            let amountCourses = Int.random(in: 1...4)
            var resultCourses = Set<Course>()

            while amountCourses != resultCourses.count {

                let randomCourse = coursesOfStudent.randomElement()!

                resultCourses.insert(randomCourse)

            }
            student.courses = resultCourses as NSSet
        }

        DataManager.sharedManager.saveContext()

        let request = NSFetchRequest<Teacher>(entityName: "Teacher")
        var result = [Teacher]()
        do {
           result = try DataManager.sharedManager.managedObjectContext.fetch(request)
        } catch let error {
            print(error.localizedDescription)
        }

        result.forEach { (t) in
            print("\(t.name ?? "nil") \(t.lastName ?? "nil")")
        }
*/
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        DataManager.sharedManager.saveContext()
    }

    
}

