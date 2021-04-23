import UIKit
import Firebase
class ViewController: UIViewController {

    @IBOutlet weak var eMailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
    }

    @IBAction func signInClicked(_ sender: Any) {
        if eMailText.text != "" && passwordText.text != "" {
            Auth.auth().signIn(withEmail: eMailText.text!, password: passwordText.text!) { (authdata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error!.localizedDescription, buttonTitle: "OK")
                }
                else {
                    self.performSegue(withIdentifier: "toHomeVC", sender: nil)
                }
                
            }
        }
        else {
            makeAlert(titleInput: "Error", messageInput: "Email and password not empty!", buttonTitle: "OK")
        }
    
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if eMailText.text != "" && passwordText.text != "" {
            Auth.auth().createUser(withEmail: eMailText.text!, password: passwordText.text!) { (authdata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error" , messageInput: error!.localizedDescription, buttonTitle: "OK")
                }
                else {
                    self.performSegue(withIdentifier: "toHomeVC", sender: nil)
                }
            }
        }
        else {
            makeAlert(titleInput: "Error", messageInput: "Email and password not empty", buttonTitle: "OK" )
        }
    }
    
    
    func makeAlert(titleInput: String, messageInput: String, buttonTitle: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
}

