import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    
    var def = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if def {
            nameTextField.placeholder = "Имя"
            surnameTextField.placeholder = "Фамилия"
        }
        nameTextField.placeholder = Persistance.shared.userName
        surnameTextField.placeholder = Persistance.shared.userSurame
    }
    @IBAction func doneButеon(_ sender: Any) {
        def = false
        Persistance.shared.userName = nameTextField.text
        Persistance.shared.userSurame = surnameTextField.text
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
}
