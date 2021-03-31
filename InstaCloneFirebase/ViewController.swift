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
                    self.makeAlert(titleInput: "Error", messageInput: error!.localizedDescription)
                }
                else {
                    self.performSegue(withIdentifier: "toHomeVC", sender: nil)
                }
                
            }
        }
        else {
            makeAlert(titleInput: "Error", messageInput: "Email and password not empty!")
        }
    
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if eMailText.text != "" && passwordText.text != "" {
            Auth.auth().createUser(withEmail: eMailText.text!, password: passwordText.text!) { (authdata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error" , messageInput: error!.localizedDescription)
                }
                else {
                    self.performSegue(withIdentifier: "toHomeVC", sender: nil)
                }
            }
        }
        else {
            makeAlert(titleInput: "Error", messageInput: "Email and password not empty" )
        }
    }
    
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
}

