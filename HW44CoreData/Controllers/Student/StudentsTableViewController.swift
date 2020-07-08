//
//  StudentsTableViewController.swift
//  HW44CoreData
//
//  Created by Сергей on 19.05.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//


//Ученик.
//
//✅1. Делаем экран со списком юзеров. На пенели навигации есть плюсик, который добавляет нового юзера. При добавлении либо редактировании юзера мы переходим на экран, гдето можем вводить его данные в динамической(!) таблице: имя, фамилия, почтовый ящик.
//
//✅2. Юзеров можно добавлять, удалять и редактировать.
//
//✅3. Добавляем UITabBarController к проекту! Приложение стартует с него и наш экран с юзерами это всего лишь один из табов. Разберитесь с этим контроллером самостоятельно. Делайте его в сториборде. Для каждого контроллера в табах делайте навигейшн, чтобы была у всех панелька навигации. То есть идет так ТабКонтроллер -> таб-> Навигейшн -> наш экран
//
//Студент.
//
//✅4. Добавте экран с курсами. На этом экране вы можете добавить, редактировать и удалить курс. Так же само как и в случае с юзерами у вас открывается контроллер редактирования. Также динамическая таблица
//
//✅5. Впервой секции идут поля "название курса", "предмет", "отрасль" и преподаватель (имя и фамилия).
//
//✅6. Во второй секции идет список юзеров, которые подписаны на курс. Можно юзера удалить, тогда он не удаляется из юзеров - он удаляется из курса. Также есть ячейка добавить студентов. (например первая ячейка в секции)
//
//✅7. если я нажимаю на ячейку студента, то перехожу к его профайлу.
//
//Мастер
//
//✅8. Если я нажимаю на ячейке добавить сдудентов, то мне выходит модальный контроллер либо поповер, содержащий список всех юзеров, причем юзеры которые выбрали этот курс имеют галочки. Тут я могу снимать студентов с курса либо добавлять на этот курс новых студентов.
//
//✅9. Так же и для преподавателя: если нажать на ячейку с преподавателем - переходишь к экрану юзеров, но тут можно выбрать только одного на этот раз.
//
//✅10. Если преподаватель выбран, то ячейка "преподаватель" на экране редактирования курса должна содержать его имя и фамилию, если нет - должен быть текст "выберите преподавателя"
//
//✅11. Тоже самое сделайте на экране юзеров, мы ведь там сделали динамическую таблицу также. Добавте секцию "курсы, которые ведет" и добавьте туда все его курсы. Также добавьте секцию "курсы, которые изучает". Если у студента нет курсов в какой-либо из этих секций - не показывайте секцию :)
//
//Супермен.
//
//✅12. Сделать все вышеперечисленное
//
//13. Сделайте третий экран - преподаватели. На этом экране будет выводиться список всех преподавателей сгрупированных по "предмету" (например программирование). У каждого преподавателя видно количество курсов (просто цифра) и если нажать на преподавателя, то переходишь в его профайл.
//
//Вот такое вот задание!
//5
//Нравится
//Показать список оценивших
//Ответить
//Алексей Скутаренко
//Алексей Скутаренко 17 фев 2014 в 6:58
//Добавил домашнее задание! Может показаться, что оно сложное, но это капля в море по сравнению с реальным проектом, привыкайте!

import UIKit
import CoreData

class StudentsTableViewController: CoreDataTableViewController {

    var students = [Student]()
    
    //MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupNavigationItem()
        
        self.navigationItem.title = "Students"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                   target: self,
                                                                   action: #selector(addStudent) )
        self.settingsTabBarItems()
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
        let imageView = UIImageView(image: UIImage(named: "studentss"))
        navigationItem.titleView = imageView
    }
    
    //MARK: - Selectors
    
    @objc private func addStudent() {
        let studentEditingTableVC = StudentEditingTableVC()
        self.navigationController?.show(studentEditingTableVC, sender: nil)
    }

    //Help Methods
    private func settingsTabBarItems() {
        tabBarController?.tabBar.items?[0].image = UIImage(named: "studentss")
        tabBarController?.tabBar.items?[0].title = "Studets"
        tabBarController?.tabBar.items?[1].image = UIImage(named: "courses")
        tabBarController?.tabBar.items?[1].title = "Courses"
        tabBarController?.tabBar.items?[2].image = UIImage(named: "teach")
        tabBarController?.tabBar.items?[2].title = "Teachers"
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
        
        let reuseIdentifier = "Cell"
        var cellOfStudent = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cellOfStudent == nil {
            cellOfStudent = UITableViewCell(style: .value1, reuseIdentifier: reuseIdentifier)
        }
        let studentByIndexPath = fetchedResultsController.object(at: indexPath)
        self.configureCell(cellOfStudent!, object: studentByIndexPath)
        
        return cellOfStudent!
    }
    
    override func configureCell(_ cell: UITableViewCell, object: Any) {
     
        let student = object as! Student
        cell.imageView?.image = UIImage(named: "student")
        cell.textLabel?.text = "\(student.firstName ?? "nil") \(student.lastName ?? "nil")"
        cell.detailTextLabel?.text = "ID: \(student.id)"
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
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK: - UITAbleViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let student = fetchedResultsController.object(at: indexPath) as! Student
        let studentEditingTableVC = StudentEditingTableVC()
        studentEditingTableVC.student = student

        navigationController?.show(studentEditingTableVC, sender: self)
        
    }

    // MARK: - Fetched results controller

    override var fetchedResultsController: NSFetchedResultsController<NSManagedObject> {
        
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>.init(entityName: "Student")
        fetchRequest.fetchBatchSize = 20
        let sortDescriptor = NSSortDescriptor(key: "firstName", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let aFetchedResultsController =
            NSFetchedResultsController(fetchRequest: fetchRequest,
                                       managedObjectContext: self.managedObjectContext,
                                       sectionNameKeyPath: nil,
                                       cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
             let nserror = error as NSError
             fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
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
