//
//  Teacher+CoreDataProperties.swift
//  HW44CoreData
//
//  Created by Сергей on 29.06.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//
//

import Foundation
import CoreData


extension Teacher {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Teacher> {
        return NSFetchRequest<Teacher>(entityName: "Teacher")
    }

    @NSManaged public var lastName: String?
    @NSManaged public var name: String?
    @NSManaged public var course: NSSet?

}

// MARK: Generated accessors for course
extension Teacher {

    @objc(addCourseObject:)
    @NSManaged public func addToCourse(_ value: Course)

    @objc(removeCourseObject:)
    @NSManaged public func removeFromCourse(_ value: Course)

    @objc(addCourse:)
    @NSManaged public func addToCourse(_ values: NSSet)

    @objc(removeCourse:)
    @NSManaged public func removeFromCourse(_ values: NSSet)

}
