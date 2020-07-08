//
//  Course+CoreDataProperties.swift
//  HW44CoreData
//
//  Created by Сергей on 29.06.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//
//

import Foundation
import CoreData


extension Course {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Course> {
        return NSFetchRequest<Course>(entityName: "Course")
    }

    @NSManaged public var name: String?
    @NSManaged public var sphere: String?
    @NSManaged public var subjectOfStudy: String?
    @NSManaged public var students: NSSet?
    @NSManaged public var teacher: Teacher?

}

// MARK: Generated accessors for students
extension Course {

    @objc(addStudentsObject:)
    @NSManaged public func addToStudents(_ value: Student)

    @objc(removeStudentsObject:)
    @NSManaged public func removeFromStudents(_ value: Student)

    @objc(addStudents:)
    @NSManaged public func addToStudents(_ values: NSSet)

    @objc(removeStudents:)
    @NSManaged public func removeFromStudents(_ values: NSSet)

}
