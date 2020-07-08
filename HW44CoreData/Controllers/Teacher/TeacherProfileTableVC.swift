//
//  TeacherProfileTableVC.swift
//  HW44CoreData
//
//  Created by Сергей on 01.07.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

import UIKit

enum TypeSection: Int {
    case image
    case personalInfo
    case teachesCourses
}

class TeacherProfileTableVC: UITableViewController {

    var teacher: Teacher? = nil
    var sections: [Section]? = nil
    
    lazy var createSections: [Section] = {
        var sections = [Section]()
        for (ind , name) in Constants.namesOfSections.enumerated() {
            switch TypeSection.init(rawValue: ind) {
                case .image:
                    sections.append(Section(name: name, objects: ["teacher"]))
                case.personalInfo:
                    sections.append(Section(name: name, objects: [teacher?.name as Any, teacher?.lastName as Any]))
                case .teachesCourses:
                    sections.append(Section(name: name, objects: teacher?.course?.allObjects ))
                default:
                    break
            }

        }
        return sections
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: Constants.imageOfTeacher)
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.sections = createSections
        
    }

    //MARK: Help Functions

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections?[section].name
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections?[section]
        let numberOfRows = section?.objects?.count ?? 0
        return numberOfRows
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "reuseIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        cell = cell ?? UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        configure(cell: cell, by: indexPath)
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let typeSection = TypeSection(rawValue: indexPath.section)
        
        return typeSection == .image ? Constants.heightCell.increased : Constants.heightCell.standart
    }
    
    private func configure(cell: UITableViewCell?, by indexPath: IndexPath) {
        
        let typeSection = TypeSection(rawValue: indexPath.section)
        switch typeSection {
            case .image:
                cell?.frame = CGRect(x: 0, y: 0, width: 320,
                                     height: Constants.heightCell.increased)
                cell?.addSubview(imageView)
                settingConstraintsFor(imageView: imageView, cell: cell)
            case .personalInfo:
                configureForPersonalInfoIn(cell: cell, indexPath: indexPath)
            case .teachesCourses:
                configureForTeachesCoursesIn(cell: cell, indexPath: indexPath)
            default:
                break
        }
        
        
    }
    
    
    //MARK: Help Methods
    
    private func settingConstraintsFor(imageView: UIImageView?, cell: UITableViewCell?) {
        imageView?.frame = CGRect(x: 100, y: 0,
                                  width: Constants.heightCell.increased,
                                  height: Constants.heightCell.increased)
    }
    
    private func configureForPersonalInfoIn(cell: UITableViewCell?, indexPath: IndexPath) {
        let section = sections?[indexPath.section]
        let nameOfTeacher = section?.objects?[indexPath.row] as! String
        cell?.textLabel?.text = "\(nameOfTeacher)"
    }
    
    private func configureForTeachesCoursesIn(cell: UITableViewCell?, indexPath: IndexPath) {
        let section = sections?[indexPath.section]
        let teachesCourses = section?.objects?[indexPath.row] as! Course
        cell?.textLabel?.text = "\(teachesCourses.name ?? "nil")"
    }

}
