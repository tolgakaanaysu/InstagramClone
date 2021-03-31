
import UIKit
import Firebase
class ProfileVC: UIViewController, UITableViewDelegate,UITableViewDataSource {
   
    var emailArray = [String]()
    var commentArray = [String]()
    var likeArray = [Int]()
    var urlArray = [String]()
    var indexPathRow = Int()
    var postIDArray = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    let fireStoreDatabase = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    
        getData()
        

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: self, action: #selector(toSettingsVC))
        
        
      }
    
    @objc func toSettingsVC(){
        performSegue(withIdentifier: "toSettingVC", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileCell
       
        cell.commentLabel.text = commentArray[indexPath.row]
        cell.epostaLabel.text = emailArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.imageviewProfile.sd_setImage(with: URL(string: self.urlArray[indexPath.row]))
        cell.postIdLabel.text = postIDArray[indexPath.row]
       return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return emailArray.count
        
    }
    
    func getData(){
        fireStoreDatabase.collection("Posts").order(by: "Date",descending: true).addSnapshotListener { (snapshot, error) in
                
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                if snapshot?.isEmpty != true && snapshot?.isEmpty != nil {
                    
                    self.emailArray.removeAll(keepingCapacity: false)
                    self.urlArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.commentArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                       if let email = document.get("postedBy") as? String {
                            let docID = document.documentID
                            self.postIDArray.append(docID)
                        
                    
                            if email == Auth.auth().currentUser?.email  {
                                self.emailArray.append(email)
                            
                                if let like = document.get("like") as? Int {
                                    self.likeArray.append(like)
                                }
                            
                                if let comment = document.get("postComment") as? String {
                                    self.commentArray.append(comment)
                                }
                            
                                if let url = document.get("imageUrl") as? String {
                                    self .urlArray.append(url)
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
