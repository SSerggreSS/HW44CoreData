//
//  ListOfTeachersTableViewController.swift
//  HW44CoreData
//
//  Created by Сергей on 23.06.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

import UIKit
import CoreData

protocol ListOfTeachersTableViewControllerDelegate {
    func didSelect(teacher: Teacher)
}

class ListOfTeachersTableViewController: CoreDataTableViewController {

    var selectedTeacher: Teacher? = nil
    var delegate: ListOfTeachersTableViewControllerDelegate? = nil
    
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

    override var fetchedResultsController: NSFetchedResultsController<NSManagedObject> {

        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let requestTeacher = NSFetchRequest<NSManagedObject>(entityName: "Teacher")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        requestTeacher.sortDescriptors = [sortDescriptor]
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: requestTeacher,
                                                                   managedObjectContext: self.managedObjectContext,
                                                                   sectionNameKeyPath: nil,
                                                                   cacheName: nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController?.performFetch()
        } catch let error {
            fatalError(error.localizedDescription)
        }

        return _fetchedResultsController!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "Cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        cell = cell ?? UITableViewCell()
        configureCell(cell!, indexPath: indexPath)
        return cell!
    }
    
    func configureCell(_ cell: UITableViewCell, indexPath: IndexPath) {
        let teacher = self._fetchedResultsController?.object(at: indexPath) as! Teacher
        var indexTeacher = IndexPath()
        if self.selectedTeacher != nil {
            indexTeacher = self._fetchedResultsController?.indexPath(forObject: self.selectedTeacher!) as! IndexPath
        }
        if indexPath == indexTeacher {
            cell.accessoryType = .checkmark
        }
        cell.textLabel?.text = (teacher.name ?? "nuuul") + " " + (teacher.lastName ?? "noool")
        if teacher.name == nil || teacher.lastName == nil {
            print("teachername or lastname = nil")
        }
        cell.imageView?.image = UIImage(named: "teacher")
    }
}

//MARK: UITableViewDelegate

extension ListOfTeachersTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.visibleCells.forEach { (cell) in
            cell.accessoryType = .none
        }
        let selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.accessoryType = selectedCell?.accessoryType == .checkmark ? .none : .checkmark
        let teacher = self._fetchedResultsController?.object(at: indexPath) as! Teacher
        delegate?.didSelect(teacher: teacher)
    }
    
}


