//
//  SettingsVC.swift
//  InstaCloneFirebase
//
//  Created by Tolga Kağan Aysu on 20.03.2021.
//

import UIKit
import Firebase
class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
       
    @IBAction func logoutButtonClicked(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toViewController", sender: nil)
        }catch {
            print("Log out error")
        }
        
    }
}
