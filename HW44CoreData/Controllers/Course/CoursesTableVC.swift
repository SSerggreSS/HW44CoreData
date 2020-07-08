//
//  CoursesTableVC.swift
//  HW44CoreData
//
//  Created by Сергей on 25.05.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

import UIKit
import CoreData

class CoursesTableVC: CoreDataTableViewController {

    //MARK: Life Circle
    override func loadView() {
        super.loadView()
        
        setupNavigationBar()
        setupNavigationItem()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(addNewCourse))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingsNavigationItems()
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
        let imageView = UIImageView(image: UIImage(named: "courses"))
        navigationItem.titleView = imageView
    }
    
    //MARK: Actions
    
    @objc private func addNewCourse() {
        let courseEditingTableVC = CourseEditTableVC()
        self.navigationController?.show(courseEditingTableVC, sender: self)
    }
    
    private func settingsNavigationItems() {
        self.navigationItem.title = Constants.tabBarItemsTitles.second
    }
    

    // MARK: - Table View Data Sourse

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reusableIdentifier = "Cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier)
        cell = cell ?? UITableViewCell(style: .value1, reuseIdentifier: reusableIdentifier)
        let course = self.fetchedResultsController.object(at: indexPath)
        configureCell(cell!, object: course)
        
        return cell!
    }

    override func configureCell(_ cell: UITableViewCell, object: Any) {
            let course = object as! Course
            cell.imageView?.image = UIImage(named: "course")
            cell.textLabel?.text = "\(course.name ?? "nil")"
            cell.accessoryType = .disclosureIndicator
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath))
                
            do {
                try context.save()
            } catch let error {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - Fetched results controller
    //computed property this abstract
    override var fetchedResultsController: NSFetchedResultsController<NSManagedObject> {
        
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequestCourse = NSFetchRequest<NSManagedObject>.init(entityName: "Course")
        let sortDescriptorByName = NSSortDescriptor(key: "name", ascending: true)
        fetchRequestCourse.sortDescriptors = [sortDescriptorByName]
        fetchRequestCourse.relationshipKeyPathsForPrefetching = ["students"]
        
        let aFetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequestCourse,
                                                                 managedObjectContext: managedObjectContext,
                                                                 sectionNameKeyPath: nil,
                                                                 cacheName: nil)
        aFetchResultsController.delegate = self
       
        self._fetchedResultsController = aFetchResultsController
        
        do {
            try self._fetchedResultsController?.performFetch()
        } catch let nsError as NSError {
            fatalError(nsError.description)
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

    //MARK: UITableViewDelegate
extension CoursesTableVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let courseEditingTableVC = CourseEditTableVC()
        let selectedCourse = self.fetchedResultsController.object(at: indexPath) as! Course
        courseEditingTableVC.course = selectedCourse
        self.navigationController?.show(courseEditingTableVC, sender: self)
        
    }
}
