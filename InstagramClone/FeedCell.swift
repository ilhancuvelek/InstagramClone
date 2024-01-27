//
//  FeedCell.swift
//  InstagramClone
//
//  Created by İlhan Cüvelek on 21.01.2024.
//

import UIKit
import Firebase
class FeedCell: UITableViewCell {
    
    @IBOutlet weak var usernameText: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var documentIdLabel: UILabel!
    
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        configureLikeButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        
        let fireStoreDatabase = Firestore.firestore()
        
        if let likeCount = Int(likeLabel.text!) {
            
            if likeCount < 1 {
                let likeStore = ["likes" : likeCount + 1] as [String : Any]
                
                //Güncelleme işlemi
                fireStoreDatabase.collection("Posts").document(documentIdLabel.text!).setData(likeStore, merge: true)
                
            }else if likeCount == 1{
                let likeStore = ["likes" : 0] as [String : Any]
                
                //Güncelleme işlemi
                fireStoreDatabase.collection("Posts").document(documentIdLabel.text!).setData(likeStore, merge: true)
            }
        }
    }
    func configureLikeButton() {
        if let likeCount = Int(likeLabel.text!) {
            if likeCount == 0 {
                likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            } else {
                likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
        }
    }

    

}
