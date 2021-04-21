import UIKit
import Firebase
class HomeCell: UITableViewCell {

    @IBOutlet weak var UserLikeLabel: UILabel!
    @IBOutlet weak var UserLikeButton: UIButton!
    @IBOutlet weak var UserCommentLabel: UILabel!
    @IBOutlet weak var UserEmailLabel: UILabel!
    @IBOutlet weak var UserImageView: UIImageView!
    @IBOutlet weak var IDLabel: UILabel!

    var likedByArray = [String]()
    var likeID = UUID()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    @IBAction func likeButtonClicked(_ sender: Any) {
       
       
     
        let auth = Auth.auth().currentUser
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Posts").addSnapshotListener { (snapshot, error) in
            if error != nil {
             
                print(error!.localizedDescription)
             
            }
            else {
                if snapshot?.isEmpty != true {
                    
                    for document in snapshot!.documents {
                        if let likedBy = document.get("likedBy") as? [String] {
                            self.likedByArray.append(contentsOf: likedBy)
                            
                           
                        }
                    }
                    
                }
                else {
                    

                }
                
            }
        }
        
        // Kullanıcı kendi fotoğrafını beğenemez
        // Kullanıcı diğer fotoğrafları bir kere beğenebilir
        
        for didLike in likedByArray {
            if auth!.email == UserEmailLabel.text || didLike == auth!.email {
                likedByArray.append(auth!.email!)
                let setData = ["likedBy" : likedByArray]
                firestoreDatabase.collection("Posts").document(self.IDLabel.text!).setData(setData, merge: true)
               
                return
                
            }
        }
        
        likedByArray.append(auth!.email!)
        let setData = ["likedBy" : likedByArray]
        firestoreDatabase.collection("Posts").document(self.IDLabel.text!).setData(setData, merge: true)
        
        
        if let likeCount = Int(UserLikeLabel.text!) {
          
            let likeStore = ["like": likeCount + 1 ] as [String : Any]
            
            firestoreDatabase.collection("Posts").document(self.IDLabel.text!).setData(likeStore, merge: true)
        
        }
       
        
    }
    
}
