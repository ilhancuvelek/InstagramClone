//
//  SignUpViewController.swift
//  InstagramClone
//
//  Created by İlhan Cüvelek on 21.01.2024.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if mailText.text != "" && passwordText.text != ""{
            
            Auth.auth().createUser(withEmail: mailText.text!, password: passwordText.text!) { authData, error in
                if error != nil{
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                }else{
                    if let user = Auth.auth().currentUser {
                        let userId = user.uid
                        
                        self.saveUserToFirestore(username: self.usernameText.text!, mail: self.mailText.text!,id:String(userId))
                    }
                   

                    self.performSegue(withIdentifier: "fromSignUpToFeedVC", sender: nil)
                }
            }
        }else{
            makeAlert(titleInput: "Error!", messageInput: "Username/Password?")
        }
    }
    func saveUserToFirestore(username:String,mail:String,id:String){
        
        let db = Firestore.firestore()
        let userDocument = db.collection("users").document()
        
        let userData: [String: Any] = [
            "username": username,
            "email": self.mailText.text!,
            "userId":id
        ]
        
        userDocument.setData(userData) { error in
            if error != nil{
                self.makeAlert(titleInput: "error", messageInput:error?.localizedDescription ?? "Error")
            }
        }
    }
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }


}
