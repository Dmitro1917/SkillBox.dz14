//
//  CoreDataAddTaskViewController.swift
//  dz14
//
//  Created by Дмитро Селиванов on 15.12.2022.
//  Copyright © 2022 Дмитрий Винокуров. All rights reserved.
//

import UIKit
import CoreData

class CoreDataAddTaskViewController: UIViewController {
    
    var update: (() -> Void)?
    
    @IBOutlet weak var taskTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func doneButton(_ sender: Any) {
        if taskTextField.text != "" {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
            let taskObject = CoreDataTaskController(entity: entity, insertInto: context)
            taskObject.taskText = taskTextField.text!
            do {
                try context.save()
                update?()
                navigationController?.popViewController(animated: true)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
}
