//
//  Constants.swift
//  HW44CoreData
//
//  Created by Сергей on 20.05.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

class Constants {
    
    static let tabBarItemsTitles = (first: "Students", second: "Courses", third: "Teachers")
    
    static let firstRow = 0
    static let offset: CGFloat = 20
    
    static let emailAttrs = (dog: "@", dot: ".", dns: (where: "where.erehw", why: "why.yhw", no: "no.on"))
    
    static let stringForPlaceholder = (enterName: "Enter name please...",
                                       enterSecondName: "Enter second name please..",
                                       enterEmail: "Enter email please...")
    
    static let firstNames = ["Mason", "Ethan", "Logan", "Lucas", "Jackson",
                                 "Aiden", "Oliver", "Jacob", "Madison", "Liam",
                                 "Emma", "Olivia", "Ava", "Sophia", "Isabella",
                                 "Mia", "Charlotte", "Amelia", "Emily", "Sofia",
                                 "Daniel", "Ellie", "Carter", "Aubrey", "Gabriel",
                                 "Scarlett", "Henry", "Zoey", "Matthew","Hannah"]
        
    static let lastNames = ["Johnson", "Williams", "Jones", "Brown", "Davis",
                                "Miller", "Wilson", "Moore", "Taylor", "Anderson",
                                "Thomas", "Jackson", "White", "Harris", "Martin",
                                "Thompson", "Wood", "Lewis", "Scott", "Hill",
                                "Cooper", "King", "Green", "Walker", "Edwards",
                                "Turner", "Morgan", "Baker", "Hill", "Phillips"]
    
    static let namesCourses = ["iOS", "Psychoanalysis", "Structure Of The Engine", "Acting"]
    
    static let subjectsOfStudy = ["Mobile Development", "Causes Of Positive Emotions", "Electromotor", "Drama"]
    
    static let spheresSubjectsOfStudy = ["Information Technology", "Psychology", "Motor Industry", "Art"]

    static let placeholdersForCourse = ["Enter Name Course", "Enter Subject", "Enter Sphere", "Enter Name Teacher"]
    
    static let textFieldXAndY = (x: CGFloat(60), y: CGFloat(0) )
    
    //MARK: For Section
    
    static let namesOfSections = ["Image", "Personal Information", "Teaches Courses"]
    
    //MARK: For Cell
    
    static let heightCell = (increased: CGFloat(180), standart: CGFloat(44))
    
    //MARK: Images
    
    static let imageOfStudent = UIImage(named: "student")
    static let imageOfTeacher = UIImage(named: "teacher")
    static let imageOfCourse  = UIImage(named: "course")
    static let imageOfEdit    = UIImage(named: "edit")
    static let imageOfTap     = UIImage(named: "tap")
}
