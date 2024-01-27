//
//  UploadViewController.swift
//  InstagramClone
//
//  Created by İlhan Cüvelek on 21.01.2024.
//

import UIKit
import Firebase
import FirebaseStorage

class UploadViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var descriptionText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    @objc func chooseImage() {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    

    
    @IBAction func uploadClicked(_ sender: Any) {
        // firebase de storage kısmına gidip referans oluşturduk.
        let storage = Storage.storage()
        let storageReference = storage.reference()

        // storagede media klasörüne ulaştık.
        let mediaFolder = storageReference.child("media")

        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString //her resime farklı isim vermek için.
            
            let imageReference = mediaFolder.child("\(uuid).jpg")//media klasörünün altına resim ekledik.
            
            imageReference.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            
                            let imageUrl = url?.absoluteString// resim için url oluştu
                            
                            //DATABASE --> Cloud Firestore
                            
                            let firestoreDatabase = Firestore.firestore() //firestore a ulaştık
                            
                            var firestoreReference : DocumentReference? = nil //referans oluşturduk

                            //key-value şeklinde ekleme yapıldı.( dictionary )
                            let userid=Auth.auth().currentUser?.uid
                            let strUserId=String(userid!)
                            
                            let firestorePost = ["userId":strUserId, "imageUrl" : imageUrl!, "postedBy" : Auth.auth().currentUser!.email!, "postComment" : self.descriptionText.text!,"date" : FieldValue.serverTimestamp(), "likes" : 0 ] as [String : Any]

                            //Posts ismindeki collection a ekleme yaptık.
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                                if error != nil {
                                    
                                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                                    
                                } else {
                                    print("ssucces")
                                    // ekledikten sonra ekranı temizle
                                    self.imageView.image = UIImage(named: "select.png")
                                    self.descriptionText.text = ""
                                    self.tabBarController?.selectedIndex = 0//burada tabcontroller daki kısımlar (bu proje için feed-upload-settings)
                                    
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
}
