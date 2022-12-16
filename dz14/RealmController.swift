import UIKit
import RealmSwift

class RealmController: UIViewController {
    
    let realm = try! Realm()

    var tasks = [""]
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addTaskButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "realmNewTask") as! RealmAddTaskViewController
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
        let realmTasks = realm.objects(Tasks.self)
        for task in realmTasks {
            tasks.append("\(task.taskText)")
        }
        tableView.reloadData()
    }
}

extension RealmController: UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        tableHeight.constant = CGFloat(50 * tasks.count)
        let cellCount = tasks.count
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RealmCell") as! RealmCell
//        cell.taskLabel.delegate = self
        cell.taskLabel.text = tasks[indexPath.row]
        return cell
    }
}

extension RealmController {
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
    } else {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
    }
}
}

extension RealmController {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let realm = try! Realm()
        
            let deleteAction = UITableViewRowAction(style: .destructive, title: "Удалить") {
                _, indexPath in
                self.tasks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                let allTasks = realm.objects(Tasks.self)
                try! realm.write{
                    realm.delete(allTasks)
                }
                for task in self.tasks {
                let newTask = Tasks()
                newTask.taskText = task
                    try! realm.write{
                        realm.add(newTask)
                }
                }
            }
            
            return [deleteAction]
        }
}
