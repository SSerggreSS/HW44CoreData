//
//  StudentEditingTableVC.swift
//  HW44CoreData
//
//  Created by Сергей on 19.05.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

import UIKit

enum TypeOfStudentSection: Int {
    case textFields
    case courses
}

enum TypePropertyOfStudent: Int {
    case firstName
    case lastName
    case emailAddress
    case id
}

class StudentEditingTableVC: CoreDataTableViewController {

    var student: Student? = nil
    var sections: [Section]? = nil
    
    override func loadView() {
        super.loadView()
    
        self.navigationController?.delegate = self
        
        let sectionOfStudent = Section(name: "Student Info", objects: self.textFieldsOfStudent)
        let allStudentCourses = self.student?.courses?.allObjects.sorted(by: { (lCourse, rCourse) -> Bool in
            return ((lCourse as! Course).name ?? "") < ((rCourse as! Course).name ?? "")
        })
        let sectionStudentCourses = Section(name: "Student Courses", objects: allStudentCourses)
        self.sections = [sectionOfStudent, sectionStudentCourses]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = self.student != nil ? "Info About - " + self.student!.firstName! : "Add Student"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                                 target: self,
                                                                 action: #selector(doneEditigStudent))
    }

    //MARK: Selectors
    
    @objc private func doneEditigStudent() {
        if self.allPropertiesOfStudentSet() {
            DataManager.sharedManager.saveContext()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - Setup UI
    
    private lazy var textFieldsOfStudent: [UITextField] = {
    
        var textFields = [UITextField]()
    
        for i in 0...2 {
            
            let textField = UITextField()
            textField.delegate = self
            textField.tag = i
            
            switch i {
                case 0:
                    textField.becomeFirstResponder()
                    textField.placeholder = Constants.stringForPlaceholder.enterName
                case 1:
                    textField.placeholder = Constants.stringForPlaceholder.enterSecondName
                case 2:
                    textField.placeholder = Constants.stringForPlaceholder.enterEmail
                default:
                    break
            }
            
            textFields.append(textField)
        }
        return textFields
    }()
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var titleForHeader = ""
        let typeSection = TypeOfStudentSection.init(rawValue: section)
        
        switch typeSection {
            case .textFields:
                titleForHeader = "Info Student"
            case .courses:
                titleForHeader = "Visiting Courses"
            default:
                break
        }
        
        return titleForHeader
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let someSection = self.sections?[section]
        let objectsInSection = someSection?.objects?.count ?? 0
        
        return objectsInSection
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier = "Cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        cell = cell ?? UITableViewCell(style: .value1, reuseIdentifier: reuseIdentifier)
        
        let sectionType = TypeOfStudentSection.init(rawValue: indexPath.section)
        switch sectionType {
            case .textFields:
                configureForTextFieldsStudent(cell: cell!, indexPath: indexPath)
            case .courses:
                configureForCoursesStudent(cell: cell!, indexPath: indexPath)
            default:
                break
        }
        return cell!
    }
    
    private func configureForTextFieldsStudent(cell: UITableViewCell, indexPath: IndexPath) {
        
        let sectionWithTextFields = self.sections?[indexPath.section]
        let textFieldForCell = sectionWithTextFields?.objects?[indexPath.row] as? UITextField
        textFieldForCell?.frame = CGRect(x: Constants.textFieldXAndY.x, y: Constants.textFieldXAndY.y,
                                        width: cell.bounds.width, height: cell.bounds.height)
    
        self.student = self.student ?? DataManager.sharedManager.addEmptyStudent()
        
        switch TypePropertyOfStudent.init(rawValue: indexPath.row) {
            case .firstName:
                textFieldForCell?.text = self.student?.firstName
            case .lastName:
                textFieldForCell?.text = self.student?.lastName
            case .emailAddress:
                textFieldForCell?.text = self.student?.emailAddress
            default:
                break
        }
        cell.imageView?.image = UIImage(named: "edit")
        cell.addSubview(textFieldForCell!)
    }
    
    private func configureForCoursesStudent(cell: UITableViewCell, indexPath: IndexPath) {
        let course = self.sections?[indexPath.section].objects?[indexPath.row] as? Course
        cell.imageView?.image = UIImage(named: "course")
        cell.textLabel?.text = "\(course?.name ?? "")"
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let course = self.sections?[indexPath.section].objects?.remove(at: indexPath.row) as! Course
            student?.removeFromCourses(course)
            DataManager.sharedManager.saveContext()
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}

//MARK: UITableViewDelegate

extension StudentEditingTableVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: UITextFieldDelegate

extension StudentEditingTableVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var isChanges = false
        let characterLimit = 20
        
        let text = (textField.text ?? "") as NSString
        let newString = text.replacingCharacters(in: range, with: string)
        
        if newString.count < characterLimit {
            isChanges = true
        }
        
        if student?.id == 0 {
            student?.id = Int16.random(in: 1...300)
        }
        
        switch TypePropertyOfStudent.init(rawValue: textField.tag) {
            case .firstName:
                student?.firstName = newString
            case .lastName:
                student?.lastName = newString
            case .emailAddress:
                student?.emailAddress = newString
            default:
            break
        }
        
        return isChanges
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let textFields = self.sections?[1].objects as? [UITextField]
        
        switch TypePropertyOfStudent.init(rawValue: textField.tag) {
            case .firstName:
                textFields?[1].becomeFirstResponder()
            case .lastName:
                textFields?[2].becomeFirstResponder()
            case .emailAddress:
                textField.resignFirstResponder()
            default:
                break
        }
        
        return true
    }
 
}

//MARK: UINavigationControllerDelegate

extension StudentEditingTableVC: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if !self.allPropertiesOfStudentSet() {
            DataManager.sharedManager.persistentContainer.viewContext.delete(self.student!)
        }
        
        return nil
    }
    
    private func allPropertiesOfStudentSet() -> Bool {
        
        var isAllPropertiesFilled = true
        let emptyAndFilledProperties = [!(self.student?.firstName?.isEmpty ?? true),
                                        !(self.student?.lastName?.isEmpty ?? true),
                                        !(self.student?.emailAddress?.isEmpty ?? true)]
        for isFilledProperty in emptyAndFilledProperties {
            
            switch isFilledProperty {
                case false:
                        isAllPropertiesFilled = false
                    break
                default:
                    continue
            }
            
        }
        
        return isAllPropertiesFilled
    }
    
}
