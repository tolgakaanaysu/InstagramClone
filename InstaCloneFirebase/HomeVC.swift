import UIKit
import Firebase
import SDWebImage
class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var emailArray = [String]()
    var commentArray = [String]()
    var likeArray = [Int]()
    var urlArray = [String]()
    var documentIDArray = [String]()
    var likedByArray = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! HomeCell
       
        cell.IDLabel.text = documentIDArray[indexPath.row]
        cell.UserCommentLabel.text = commentArray[indexPath.row]
        cell.UserEmailLabel.text = emailArray[indexPath.row]
        cell.UserLikeLabel.text = String(likeArray[indexPath.row])
        cell.UserImageView.sd_setImage(with: URL(string: self.urlArray[indexPath.row]))

        if likedByArray.isEmpty ==  true {
            cell.likedByArray = self.likedByArray[Int()]
        }
        else {
            cell.likedByArray = self.likedByArray[indexPath.row]
        }
       
       return cell
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    
    }
    
    func getDataFromFirestore(){
       
        let fireStoreDatabase = Firestore.firestore()
        
        fireStoreDatabase.collection("Posts").order(by: "Date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
             
            }
            else {
                if snapshot?.isEmpty != true && snapshot?.isEmpty != nil  {
                    self.emailArray.removeAll(keepingCapacity: false)
                    self.commentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.urlArray.removeAll(keepingCapacity: false)
                    self.likedByArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        self.documentIDArray.append(documentID)
                        
                        if let postedBy = document.get("postedBy") as? String {
                            self.emailArray.append(postedBy)
                            
                            if let imageUrl = document.get("imageUrl") as? String {
                                self.urlArray.append(imageUrl)
                                
                                if let like = document.get("like") as? Int {
                                    self.likeArray.append(like)
                                    
                                    if let comment = document.get("postComment") as? String {
                                        self.commentArray.append(comment)
                                        
                                        if let likedBy = document.get("likedBy") as? [String]{
                                            self.likedByArray.append(likedBy)
                                        }
                                        
                                        
                                    }
                                }
                            }
                            
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
}
