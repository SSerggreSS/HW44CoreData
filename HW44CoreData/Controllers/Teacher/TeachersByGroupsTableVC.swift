//
//  TeachersByGroupsTableVC.swift
//  HW44CoreData
//
//  Created by Сергей on 29.06.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

import UIKit
import CoreData

class TeachersByGroupsTableVC: CoreDataTableViewController {

    var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            setupNavigationBar()
            setupNavigationItem()
        
            fetchedResultsController.fetchedObjects?.forEach({ (managedObject) in
            let course = managedObject as! Course
            let teacher = course.teacher ?? Teacher()
            sections.append(Section(name: course.name ?? "nil", objects: [teacher]))
        })
        
        self.navigationItem.title = "Techers"
    }
    
    //MARK: Setup Navigation Bar
    
    private func setupNavigationBar() {
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .brown
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.brown]
        
    }
    
    private func setupNavigationItem() {
        let imageView = UIImageView(image: UIImage(named: "teach"))
        navigationItem.titleView = imageView
    }

    //MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = sections[indexPath.section]
        let selectedTeacher = section.objects?[indexPath.row] as! Teacher
        let teacherProfileTableVC = TeacherProfileTableVC()
        teacherProfileTableVC.teacher = selectedTeacher
        self.navigationController?.pushViewController(teacherProfileTableVC, animated: true)
    }
    
    // MARK: - Table View Data Sourse
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        return section.objects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "Cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        cell = cell ?? UITableViewCell(style: .value1, reuseIdentifier: reuseIdentifier)
        configureCell(cell!, object: indexPath)
        
        return cell!
    }

    override func configureCell(_ cell: UITableViewCell, object: Any) {
        let indexPath = object as! IndexPath
        let section = sections[indexPath.section]
        let teacher = section.objects?[indexPath.row] as! Teacher
        cell.textLabel?.text = (teacher.name ?? "nil") + " " + (teacher.lastName ?? "nil")
        cell.detailTextLabel?.text = String(teacher.course?.count ?? 0)
        cell.imageView?.image = Constants.imageOfTeacher
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].name
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath))
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - Fetched results controller

    override var fetchedResultsController: NSFetchedResultsController<NSManagedObject> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Course")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let aFetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                managedObjectContext: managedObjectContext,
                                                                sectionNameKeyPath: nil,
                                                                cacheName: nil)
        aFetchResultsController.delegate = self
        _fetchedResultsController = aFetchResultsController
        do {
            try _fetchedResultsController?.performFetch()
        } catch let error {
            fatalError(error.localizedDescription)
        }
        
        return _fetchedResultsController!
    }

    override func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    override func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert:
                tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete:
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            default:
                return
        }
    }

    override func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .fade)
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .fade)
            case .update:
                configureCell(tableView.cellForRow(at: indexPath!)!, object: anObject)
            case .move:
                configureCell(tableView.cellForRow(at: indexPath!)!, object: anObject)
                tableView.moveRow(at: indexPath!, to: newIndexPath!)
            default:
                return
        }
    }

    override func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

}
