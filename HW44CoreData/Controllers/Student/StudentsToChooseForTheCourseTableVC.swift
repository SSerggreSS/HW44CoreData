//
//  StudentsToChooseForTheCourseTableVC.swift
//  HW44CoreData
//
//  Created by Сергей on 07.06.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

import UIKit
import CoreData

class StudentsToChooseForTheCourseTableVC: CoreDataTableViewController {

    var course: Course? = nil
    var delegate: CourseEditTableVCDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let infoSection = self.fetchedResultsController.sections?[section]
        return infoSection?.numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let reuseIdentifier = "Cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        cell = cell ?? UITableViewCell()
    
        let student = fetchedResultsController.fetchedObjects?[indexPath.row] as! Student
        self.configureCell(cell!, object: student)

        return cell!
    }
    
    override func configureCell(_ cell: UITableViewCell, object: Any) {
    
        let student = object as! Student
        cell.textLabel?.text = student.firstName! + " " + student.lastName!
        
        let isSubscribedToTheCourse = self.course?.students?.contains(student) ?? false
        if isSubscribedToTheCourse {
            cell.accessoryType = .checkmark
        }
        
        cell.imageView?.image = Constants.imageOfStudent
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath)
        let isHasCheckMark = selectedCell?.accessoryType == .checkmark
        let selectedStudent = self.fetchedResultsController.object(at: indexPath) as! Student
        
        if isHasCheckMark {
            selectedCell?.accessoryType = .none
            self.course?.removeFromStudents(selectedStudent)
            self.delegate?.deleted(student: selectedStudent, by: indexPath)
        } else {
            selectedCell?.accessoryType = .checkmark
            self.course?.addToStudents(selectedStudent)
            self.delegate?.added(student: selectedStudent, by: indexPath)
        }
        DataManager.sharedManager.saveContext()
    }

    // MARK: - Fetched results controller
    //computed property this abstract
    override var fetchedResultsController: NSFetchedResultsController<NSManagedObject> {
        
        if self._fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Student")
        let sortDescriptorByName = NSSortDescriptor(key: "firstName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptorByName]
        
        let aFetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                managedObjectContext: self.managedObjectContext,
                                                                sectionNameKeyPath: nil,
                                                                cacheName: nil)
        
        do {
           try aFetchResultsController.performFetch()
        } catch let nsError as NSError {
            fatalError(nsError.description)
        }
        
        _fetchedResultsController = aFetchResultsController
        
        return self._fetchedResultsController!
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
