//
//  CourseEditTableVC.swift
//  HW44CoreData
//
//  Created by Сергей on 28.05.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

//Руководствоваться правилами из книги чистый код

import UIKit
import CoreData

protocol CourseEditTableVCDelegate {
    func deleted(student: Student, by indexPath: IndexPath)
    func added(student: Student, by indexPath: IndexPath)
}

enum TypePropertyOfCourse: Int {
    case name
    case subjectOfStudy
    case sphere
    case teacher
    case students
}

enum TypeSectionOfCourse: Int {
    case properties = 0
    case enumerationStudents = 1
}

enum TypeOfCellContent: Int {
    case course
    case student
}

class CourseEditTableVC: UITableViewController {

    var course: Course? = nil
    var sections: [Section?]? = nil
    
    let alert = UIAlertController(title: "Not all fields are filled in or you haven't made any changes",
                                  message: "Please fill in all the fields to add and save the course or make changes",
                                  preferredStyle: .alert)
    
    lazy var textFields: [UITextField] = {
        
        var fields = [UITextField]()
        
        for i in 0...2 {
            let field = UITextField()
            field.tag = i
            field.delegate = self
            field.placeholder = Constants.placeholdersForCourse[i]
            fields.append(field)
        }
        
        return fields
    }()
    
    //MARK: - Life Circle
    
    override func loadView() {
        super.loadView()
        
        self.navigationItem.title = "Edit Course"
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupSections()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addNewCourseAndSaveInDataBase))
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    private func setupSections() {
        
        let sectionCourse = Section(name: "Corse", objects: textFields)
        var sectionStudents: Section? = nil
        
        if self.course?.students != nil {
            sectionStudents = Section(name: "Students", objects: Array<Any>.init((course?.students)!))
        } else {
            sectionStudents = Section(name: "Students", objects: nil)
        }
        
        self.sections = [sectionCourse, sectionStudents]
        
    }
    
    @objc private func addNewCourseAndSaveInDataBase() {
        
        if self.allCourseFieldsAreFilled() && !DataManager.containsInDataBase(theCourse: self.course){
            
            let teacher = NSEntityDescription.insertNewObject(forEntityName: "Teacher", into: DataManager.sharedManager.managedObjectContext) as! Teacher
            let course = NSEntityDescription.insertNewObject(forEntityName: "Course", into: DataManager.sharedManager.managedObjectContext) as! Course
            course.students = NSSet(array: self.sections?[1]?.objects ?? [Any]())
            course.name = self.textFields[0].text
            course.subjectOfStudy = self.textFields[1].text
            course.sphere = self.textFields[2].text
            teacher.name = tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.textLabel?.text
            course.teacher = teacher
            
            DataManager.sharedManager.saveContext()
            
            self.navigationController?.popViewController(animated: true)
            
        } else if DataManager.containsInDataBase(theCourse: self.course) && self.allCourseFieldsAreFilled() {
            
            self.course?.name = self.textFields[0].text
            self.course?.subjectOfStudy = self.textFields[1].text
            self.course?.sphere = self.textFields[2].text
            
            DataManager.sharedManager.saveContext()
            
            self.navigationController?.popViewController(animated: true)
            
        } else {
            self.present(self.alert, animated: true, completion: nil)
        }
        
    }
    
    private func allCourseFieldsAreFilled() -> Bool {
        
        var isAllFieldAreFilled = true
        
        for textField in self.textFields {
            if textField.text?.isEmpty ?? true {
                isAllFieldAreFilled = false
            }
        }
        
        return isAllFieldAreFilled
    }

    // MARK: - Table view data source
    //если курс нил и даже если он не нил всегда на одну ячейку больше в секции по этому секция есть всегда
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        print("self.sections?.count = \(self.sections?.count ?? 0)")
        
        
        return self.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        var numberOfRows = 0
        
        let typeSection = TypeSectionOfCourse(rawValue: section)!
        
        switch typeSection {
            
            case .properties:
                let section = self.sections?[section]
                numberOfRows = section?.objects?.count ?? 0
                numberOfRows += 1
                print("numberOfRows = \(numberOfRows)")
            case .enumerationStudents:
                let section = self.sections?[section]
                print((section?.objects?.count ?? 0))
                numberOfRows = (section?.objects?.count ?? 0) + 1
                print("numberOfRows = \(numberOfRows)")
        }
        
        return numberOfRows
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let identifier = "reuseIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        cell = cell ?? UITableViewCell(style: .value1, reuseIdentifier: identifier)
        
        let typeSection = TypeSectionOfCourse.init(rawValue: indexPath.section)!
        
        switch typeSection {
            case .properties:
                let textFieldOfCell = configureTextFieldBy(boundsOfCell: cell!.bounds, indexPath: indexPath)
                if textFieldOfCell != nil {
                    cell!.imageView?.image = Constants.imageOfEdit
                    cell!.addSubview(textFieldOfCell!)
                }
            case .enumerationStudents:
                self.configureStudent(cell: cell!, indexPath: indexPath)
        }
        
        if indexPath.row == 0 && indexPath.section == 0
                   && self.course?.teacher != nil {
                   cell?.textLabel?.text = (self.course?.teacher?.name ?? "niiil") + " " + (self.course?.teacher?.lastName ?? "niiiil")
                   print((self.course?.teacher?.name ?? "niiil") + " " + (self.course?.teacher?.lastName ?? "niiiil"))
                   cell?.imageView?.image = Constants.imageOfTap
               } else if indexPath.row == 0 && self.course?.teacher == nil
                   && indexPath.section == 0 {
                   cell?.textLabel?.text = "Tap For Select Teacher"
               }
        
        return cell!
    }
    
    private func configureTextFieldBy(boundsOfCell: CGRect, indexPath: IndexPath) -> UITextField? {
        print("indexPathFirstSection = \(indexPath)")
        
        let indexPathRow = indexPath.row != 0 ? indexPath.row - 1 : 0
        print("Fixed indexPathRow = \(indexPathRow)")
        let textField = self.textFields[indexPathRow]
        let frameForTextField = CGRect(x: Constants.textFieldXAndY.x, y: Constants.textFieldXAndY.y,
                                      width: boundsOfCell.width, height: boundsOfCell.height)
        textField.frame = frameForTextField
        
        let typePropertyOfCourse = TypePropertyOfCourse.init(rawValue: indexPathRow)
        
        switch typePropertyOfCourse {
            case .name:
                textField.text = self.course?.name
            case .subjectOfStudy:
                textField.text = self.course?.subjectOfStudy
            case .sphere:
                textField.text = self.course?.sphere
            default:
                break
        }
        return textField
    }
    
    private func configureStudent(cell: UITableViewCell, indexPath: IndexPath) {
        
        if indexPath.row == Constants.firstRow {
                cell.textLabel?.textColor = .red
                cell.textLabel?.textAlignment = NSTextAlignment.center
                cell.textLabel?.text = "ADD STUDENT"
           } else {
                let student = self.sections?[indexPath.section]?.objects?[indexPath.row - 1] as! Student
                cell.textLabel?.text = (student.firstName ?? "") + " " + (student.lastName ?? "")
                cell.accessoryType = .disclosureIndicator
                cell.imageView?.image = Constants.imageOfStudent
           }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.sections?[section]?.name
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          
        if editingStyle == .delete {
              let student =  self.sections?[indexPath.section]?.objects?.remove(at: indexPath.row - 1) as! Student
              self.course?.removeFromStudents(student)

              self.tableView.beginUpdates()
              self.tableView.deleteRows(at: [indexPath], with: .automatic)
              self.tableView.endUpdates()
          }
      }

}

//MARK: - UITextFieldDelegate

extension CourseEditTableVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var isChanges = false
        let characterLimit = 20
        
        let text = (textField.text ?? "") as NSString
        let newString = text.replacingCharacters(in: range, with: string)
        
        if newString.count < characterLimit {
            isChanges = true
        }
        
        return isChanges
    }
    
}

//MARK: - UITableViewDelegate

extension CourseEditTableVC {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == TypeSectionOfCourse.properties.rawValue &&
            indexPath.row == 0 {
            print("show list teachers")
            let listTeachers = ListOfTeachersTableViewController()
            listTeachers.delegate = self
            listTeachers.selectedTeacher = self.course?.teacher
            self.present(listTeachers, animated: true, completion: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let typeSection = TypeSectionOfCourse.init(rawValue: indexPath.section)
        
        switch typeSection {
            case .enumerationStudents where indexPath.row == 0:
                let allStudentsList = StudentsToChooseForTheCourseTableVC()
                allStudentsList.course = self.course
                allStudentsList.delegate = self
                self.present(allStudentsList, animated: true, completion: nil)
            case .enumerationStudents:
                let sectionOfStudent = self.sections?[indexPath.section]
                let student = sectionOfStudent?.objects?[indexPath.row - 1] as? Student
                let studentEditingTableVC = StudentEditingTableVC()
                studentEditingTableVC.student = student
                self.navigationController?.show(studentEditingTableVC, sender: self)
            default:
            break
        }
        
        
    }

}

//MARK: CourseEditTableVCDelegate

extension CourseEditTableVC: CourseEditTableVCDelegate {
    
    func deleted(student: Student, by indexPath: IndexPath) {
        let indexStudent = ((self.sections?[1]?.objects!)! as NSArray).index(of: student)
        self.sections?[1]?.objects?.remove(at: indexStudent)
  
        self.tableView.beginUpdates()
        let fixedIndexPath = IndexPath(row: indexStudent + 1, section: 1)
        self.tableView.deleteRows(at: [fixedIndexPath], with: .automatic)
        self.tableView.endUpdates()
    }
    
    func added(student: Student, by indexPath: IndexPath) {
        
        if self.sections?[1]?.objects == nil {
            self.sections?[1]?.objects = [Any]()
        }
        
        self.sections?[1]?.objects?.insert(student, at: 0)
        let fixedIndexPath = IndexPath(row: 1, section: 1)
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [fixedIndexPath], with: .automatic)
        self.tableView.endUpdates()
        
    }
    
}

//MARK: ListOfTeachersTableViewControllerDelegate

extension CourseEditTableVC: ListOfTeachersTableViewControllerDelegate {
    func didSelect(teacher: Teacher) {
        let cellOfTeacher = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        cellOfTeacher?.textLabel?.text = (teacher.name ?? "noool") + " " + (teacher.lastName ?? "nuuul")
        self.course?.teacher = teacher
       // DataManager.sharedManager.saveContext()
        
    }
}
