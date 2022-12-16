import UIKit
import CoreData

class CoreDataController: UIViewController {
    
    var tasks: [CoreDataTaskController] = []
    //    var tasks = ["1", "2", "3"]
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<CoreDataTaskController> = CoreDataTaskController.fetchRequest()
        
        do {
            tasks = try context .fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    @IBAction func addTaskButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "coreDataNewTask") as! CoreDataAddTaskViewController
        vc.update = {
            DispatchQueue.main.async {
                self.updateTasks()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTasks()
    }
    
    func updateTasks(){
        tasks.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<CoreDataTaskController> = CoreDataTaskController.fetchRequest()
            do {
                tasks = try context .fetch(fetchRequest)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            tableView.reloadData()
        }
    }

extension CoreDataController: UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellCount = tasks.count
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoreDataCell") as! CoreDataCell
        let textOfTask = tasks[indexPath.row]
        cell.taskLabel.text = textOfTask.taskText
        return cell
    }
}

extension CoreDataController {
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
    } else {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
    }
}
}

// Это для удаления ячеек
//extension CoreDataController {
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//
//            let deleteAction = UITableViewRowAction(style: .destructive, title: "Удалить") {
//                _, indexPath in
//            }
//
//            return [deleteAction]
//        }
//}
