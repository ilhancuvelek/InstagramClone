//
//  FeedViewController.swift
//  InstagramClone
//
//  Created by İlhan Cüvelek on 20.01.2024.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    var userEmailArray = [String]()
    var userNameArray = [String]()
    var userDescriptionArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    var userDocumentIdArray = [String]()
    var userIdArray = [String]()
    var username:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate=self
        tableView.dataSource=self
        
        if userIdArray.count>0 {
           
        }
        getDataFromFirestore()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
        getDocumentsWithCondition(userId: userIdArray[indexPath.row], completion: { username in
            cell.usernameText.text = username
        })
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.descriptionText.text = userDescriptionArray[indexPath.row]
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        cell.documentIdLabel.text = documentIdArray[indexPath.row]
        
        cell.configureLikeButton()
        
        return cell
    }
    func getDataFromFirestore() {
        
        let fireStoreDatabase = Firestore.firestore()
        
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userDescriptionArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    self.userNameArray.removeAll(keepingCapacity: false)
                    self.userIdArray.removeAll(keepingCapacity: false)

                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                        if let postedBy = document.get("postedBy") as? String {
                            self.userEmailArray.append(postedBy)
                        }
                        if let userId = document.get("userId") as? String {
                            self.userIdArray.append(userId)
                        }
                        if let postComment = document.get("postComment") as? String {
                            self.userDescriptionArray.append(postComment)
                        }
                        if let likes = document.get("likes") as? Int {
                            self.likeArray.append(likes)
                        }
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.userImageArray.append(imageUrl)
                            print(imageUrl)
                        }
                        
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }

    func getDocumentsWithCondition(userId: String, completion: @escaping (String) -> Void) {
        let db = Firestore.firestore()
        let collectionReference = db.collection("users")
        var usernameFromUser = ""

        // Örnek bir şart: userId alanı ile eşleşen belgeleri al
        collectionReference.whereField("userId", isEqualTo: userId).getDocuments { querySnapshot, error in
            if let error = error {
                print("Belgeler alınamadı: \(error.localizedDescription)")
                completion(usernameFromUser) // Hata durumunda bile geri çağrıyı çağır
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    print("Belge Verileri: \(data)")

                    if let username = data["username"] as? String {
                        usernameFromUser = username
                    }
                }
                completion(usernameFromUser) // Başarı durumunda geri çağrıyı çağır
            }
        }
    }

    

}
