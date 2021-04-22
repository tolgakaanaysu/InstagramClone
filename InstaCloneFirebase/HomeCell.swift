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
        self.likedByArray.removeAll(keepingCapacity: false)
       
       
     
        let auth = Auth.auth().currentUser
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Posts").addSnapshotListener { [self] (snapshot, error) in
            if error != nil {
                print(error!.localizedDescription)

            }
            else {
                if snapshot!.isEmpty != true && snapshot?.isEmpty != nil {
                    

                    for document in snapshot!.documents {
                        
                        if let likedBy = document.get("likedBy") as? [String] {
                            likedByArray.append(contentsOf: likedBy)
                    
                        }
                        

                    }
                
                
              
                    // Kullanıcı kendi fotoğrafını beğenemez
                    // Kullanıcı diğer fotoğrafları bir kere beğenebilir
                     
         
                    print("Burası çalışıyor 88")
                    print(likedByArray)
                    print(likedByArray.count)
                    print("Burası çalışıyor 88")
                
           
                    if likedByArray.count > 0 {
                    
                   
                        for likedby in likedByArray {
                        
                            if likedby == auth?.email {
                                isliked = true
                                return
                            }
                            
                        }
               
                    }
                
                
                    if isliked == false {
                       
                      
                        likedByArray.append(auth!.email!)
                 
                        let setData = ["likedBy" : likedByArray]
                        firestoreDatabase.collection("Posts").document(self.IDLabel.text!).setData(setData,merge:true)
                        
                 
                        let likeStore = ["like": likedByArray.count ] as [String : Any]
                        firestoreDatabase.collection("Posts").document(self.IDLabel.text!).setData(likeStore, merge: true)
                        
                        print("Buraya girdin 2")
                        print(likedByArray)
                        print("Buraya girdin 2")
                        
                    
                    
                    }
                    
                }
            }
        }
    }
}
