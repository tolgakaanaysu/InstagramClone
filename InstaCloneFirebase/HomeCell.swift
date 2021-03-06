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
    
    var isliked = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    @IBAction func likeButtonClicked(_ sender: Any) {
       
      
        let auth = Auth.auth().currentUser
      
//      Fotoğraf bir kere beğenilebilir
        if likedByArray.count > 0  {
           
            for likedby in likedByArray {
                    
                if likedby == auth?.email {
                    
                    isliked = true
                    break
                }
            }
        }
        
        if isliked == false {
            
            let firestoreDatabase = Firestore.firestore()
            likedByArray.append(auth!.email!)
     
            let setData = ["likedBy" : likedByArray]
            firestoreDatabase.collection("Posts").document(self.IDLabel.text!).setData(setData,merge:true)
                       
            let likeStore = ["like": likedByArray.count ] as [String : Any]
            firestoreDatabase.collection("Posts").document(self.IDLabel.text!).setData(likeStore, merge: true)
                                 
        }
    }
}
