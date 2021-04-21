import UIKit
import Firebase
class ShareVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var shareButtonClicked: UIButton!
    @IBOutlet weak var imageView: UIImageView!
   @IBOutlet weak var commentText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareButtonClicked.isEnabled = false
        
        let gestureRecognize = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognize)
     
    }
    
    @IBAction func cameraButtonClicked(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func libraryButtonClicked(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        present(picker, animated: true, completion: nil)
       
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        shareButtonClicked.isEnabled = true
    }
    
    @IBAction func shareButtonClicked(_ sender: Any) {
        shareButtonClicked.isEnabled = false
        
        //STORAGE
        
        let storage = Storage.storage()
        let storageReferance = storage.reference()
        
        let mediaFolder = storageReferance.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            
            let imageID = UUID().uuidString
            let imageReferance = mediaFolder.child("\(imageID).jpg")
           
            imageReferance.putData(data, metadata: nil) { (metadata, error) in
               
                if error != nil {
                    self.makeAlert(alertTitle: "Error", alertMessage: error!.localizedDescription)
                }
                else {
                    imageReferance.downloadURL { (url, error) in
                        if error == nil {
                        
                            let imageUrl = url?.absoluteString
                           
                            //DATABASE
                            let fireStoreDatabase = Firestore.firestore()
                            var fireStoreReferance : DocumentReference?
                            
                            let fireStorePost = ["imageUrl": imageUrl!, "postedBy": Auth.auth().currentUser!.email!, "postComment": self.commentText.text!, "Date": FieldValue.serverTimestamp(), "like": 0  ] as [String : Any]
                            
                            fireStoreReferance = fireStoreDatabase.collection("Posts").addDocument(data: fireStorePost, completion: { (error) in
                            
                                    if error != nil {
                                        self.makeAlert(alertTitle: "Error", alertMessage: error!.localizedDescription)
                                    }
                                    else {
                                        self.tabBarController?.selectedIndex = 0
                                        self.imageView.image = UIImage(named: "selectImage")
                                        self.commentText.text = ""
                                    }
                               }
                            )
                    
                        }
                        
                        else{
                            self.makeAlert(alertTitle: "Error", alertMessage: error!.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    func makeAlert(alertTitle: String, alertMessage: String ){
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle:
                                        UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
   
    
  
    
    
}
