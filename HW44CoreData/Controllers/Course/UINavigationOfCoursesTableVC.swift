//
//  UINavigationOfCoursesTableVC.swift
//  HW44CoreData
//
//  Created by Сергей on 25.05.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

import UIKit
import CoreData

class UINavigationOfCoursesTableVC: UINavigationController, UINavigationBarDelegate {

    //MARK: - Property UI
    let alert: UIAlertController = UIAlertController(title: "Attention: Not all fields are filled in or the course already exists",
                                                     message: "The data will not be saved or changed",
                                                     preferredStyle: .alert)
    
    //MARK: Property
    
    var courseEditTableVC: CourseEditTableVC? = nil
    
    //MARK: - LifeCircle
    
    override func loadView() {
        super.loadView()
        
            self.setupAlert()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Actions
    
    private func setupAlert() {

        let actionOk = UIAlertAction(title: "Ok", style: .default) { (actionOk) in

            if actionOk.isEnabled {
                self.popViewController(animated: true)
            }
        }
        self.alert.addAction(actionOk)

        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        self.alert.addAction(actionCancel)

    }
    
    //MARK: - UINavigationBarDelegate
    
    func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        
      var shouldPop = false

        switch self.visibleViewController {
            case _ where (self.visibleViewController?.isKind(of: ListOfTeachersTableViewController.self))!:
                shouldPop = true
            case let visibleVC where visibleVC!.isKind(of: CourseEditTableVC.self):
                self.courseEditTableVC = visibleVC as? CourseEditTableVC
                
                if DataManager.containsInDataBase(theCourse: self.courseEditTableVC?.course) {
                    self.popViewController(animated: true)
                    break
                }
                
                shouldPop = allCourseFieldsAreFilledIn(courseVC: self.courseEditTableVC!)
                shouldPop ? self.addNewCourseAndSaveDataBase() : self.present(self.alert, animated: true, completion: nil)
            case let visibleVC where (visibleVC?.isKind(of: StudentEditingTableVC.self))!:
                shouldPop = true
             default:
                    break
        }
        
        return shouldPop
    }
    
    //MARK: Actions
    
    private func allCourseFieldsAreFilledIn(courseVC: CourseEditTableVC) -> Bool {
        
        var isAllFieldAreFilled = true
        
        for textField in courseVC.textFields {
            
            if textField.text?.isEmpty ?? true {
                isAllFieldAreFilled = false
            }
            
        }
        
        return isAllFieldAreFilled
    }
    
    //the no need
   

    func addNewCourseAndSaveDataBase() {
            let course = NSEntityDescription.insertNewObject(forEntityName: "Course",
                                                             into: DataManager.sharedManager.managedObjectContext) as! Course
            course.name = self.courseEditTableVC?.textFields[TypePropertyOfCourse.name.rawValue].text
            course.subjectOfStudy = self.courseEditTableVC?.textFields[TypePropertyOfCourse.subjectOfStudy.rawValue].text
            course.sphere = self.courseEditTableVC?.textFields[TypePropertyOfCourse.sphere.rawValue].text
            DataManager.sharedManager.saveContext()
    }
    
    private func getNameAndLastNameOfTeacher() -> (name: String, lastName: String) {
        let firstAndLastName = self.courseEditTableVC?.textFields[TypePropertyOfCourse.teacher.rawValue].text
        guard !(firstAndLastName?.isEmpty ?? false) else {
            return ("NO NAME", "NO LAST NAME")
        }
        
        let elements = firstAndLastName?.split(separator: " ")
        let name = String(elements?.first ?? "nil")
        let lastName = String(elements?.last ?? "nil")
        
        return (name, lastName)
    }
    
}


