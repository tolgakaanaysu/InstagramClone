//
//  ProfileCell.swift
//  InstaCloneFirebase
//
//  Created by Tolga Kağan Aysu on 27.03.2021.
//

import UIKit
import Firebase
class ProfileCell: UITableViewCell {

    @IBOutlet weak var epostaLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var imageviewProfile: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var postIdLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
    
        let fireStoreDatabase = Firestore.firestore()
        fireStoreDatabase.collection("Posts").document(postIdLabel.text!).delete() { error in
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                ViewController().makeAlert(titleInput: "DELETE",messageInput: "Are you sure?", buttonTitle: "DELETE")
            }
        }

    }
        

    
    
    
    
    
}
