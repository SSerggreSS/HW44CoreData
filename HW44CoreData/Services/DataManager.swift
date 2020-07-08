//
//  DataManager.swift
//  HW44CoreData
//
//  Created by Сергей on 20.05.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

import Foundation
import CoreData

class DataManager {
    
   //MARK: Static Properties
    
   static var sharedManager = DataManager()
    
   //MARK: Properties
    
    var managedObjectContext: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
           
    //MARK: Static Methods
    
    static func containsInDataBase(theCourse: Course?) -> Bool {
     
        var isContains = false

        let fetchRequest = NSFetchRequest<Course>.init(entityName: "Course")
        var allCourse = [Course]()

        do {
            allCourse = try DataManager.sharedManager.managedObjectContext.fetch(fetchRequest)
        } catch let nsError as NSError {
            fatalError(nsError.localizedDescription)
        }

        for course in allCourse {
            if course.isEqual(theCourse) {
                isContains = true
            }
        }
        return isContains
    }
    
    //MARK: Add Students
    func addRandomStudentTest() -> Student {
        
        let student = NSEntityDescription.insertNewObject(forEntityName: "Student", into: self.managedObjectContext) as! Student
        
        student.firstName = Constants.firstNames.randomElement()
        student.lastName = Constants.lastNames.randomElement()
        student.emailAddress = generateRandomEmailFor(student: student)
        student.id = Int16.random(in: 1...200)
        
        return student
    }
    
    func addRandomStudentsTest(amount: Int) -> [Student] {
        
        var students = [Student]()
        
        for _ in 0..<amount {
            let student = addRandomStudentTest()
            students.append(student)
        }
        
        return students
    }
    
    func addEmptyStudent() -> Student {
        
        let student = NSEntityDescription.insertNewObject(forEntityName: "Student", into: self.managedObjectContext) as! Student
        
        return student
    }
    
    private func generateRandomEmailFor(student: Student) -> String {
        
        var email = ""
        let attributes = Constants.emailAttrs
        let attributesDNS = [attributes.dns.where, attributes.dns.no, attributes.dns.why]
        
        let leftSideEmail = Bool.random() ? (student.firstName! + student.lastName!) : (student.lastName! + student.firstName!)
        let rightSideEmail = attributes.dog + attributes.dot + attributesDNS.randomElement()!
        
        email = leftSideEmail + rightSideEmail
        
        return email
    }
    
    //MARK: Add Course
    
    func addCourses() -> [Course] {
        
        var courses = [Course]()
        
        for i in 0..<Constants.namesCourses.count {
            let course = addCourseWith(name: Constants.namesCourses[i],
                                       subjectOfStudy: Constants.subjectsOfStudy[i],
                                       sphere: Constants.spheresSubjectsOfStudy[i])
            courses.append(course)
        }
        
        return courses
    }
    
    private func addCourseWith(name: String, subjectOfStudy: String, sphere: String) -> Course {
        
        let course = NSEntityDescription.insertNewObject(forEntityName: "Course", into: self.managedObjectContext) as! Course
        
        course.name = name
        course.subjectOfStudy = subjectOfStudy
        course.sphere = sphere
        course.teacher = addRandomTeacher()
        
        return course
    }
    
    private func addRandomTeacher() -> Teacher {
        
        let teacher = NSEntityDescription.insertNewObject(forEntityName: "Teacher", into: self.managedObjectContext) as! Teacher
        
        teacher.name = Constants.firstNames.randomElement()
        teacher.lastName = Constants.lastNames.randomElement()
        
        return teacher
    }
    
    func addRandomTeachers(amount: Int) {
        for _ in 1...amount {
            let teacher = NSEntityDescription.insertNewObject(forEntityName: "Teacher", into: self.managedObjectContext) as! Teacher
            teacher.name = Constants.firstNames.randomElement()
            teacher.lastName = Constants.lastNames.randomElement()
        }
    }
    
    //MARK: - Core Data Stack
    
     lazy var persistentContainer: NSPersistentContainer = {
           let container = NSPersistentContainer(name: "HW44CoreData")
           container.loadPersistentStores { description, error in
               if let error = error {
                   fatalError("Unable to load persistent stores: \(error)")
               }
           }
           return container
       }()
    
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let nsError as NSError {
                fatalError("Unable save context reason: \(nsError.description)")
            }
        }
    }
    
    
    
}

