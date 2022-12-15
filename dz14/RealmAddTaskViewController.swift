import UIKit
import RealmSwift

class Tasks: Object {
    @objc dynamic var taskText = ""
}

class RealmAddTaskViewController: UIViewController {
    
    var update: (() -> Void)?
    
    let realmController = RealmController()
    
    let realm = try! Realm()
    
    @IBOutlet weak var taskTextField: UITextField!
    
    @IBAction func doneButton(_ sender: Any) {
        if taskTextField.text == "" { return }
        let newTask = Tasks()
        newTask.taskText = taskTextField.text!
        
        try! realm.write{
            realm.add(newTask)
        }
        update?()
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


