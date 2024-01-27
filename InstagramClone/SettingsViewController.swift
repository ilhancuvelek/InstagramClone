//
//  SettingsViewController.swift
//  InstagramClone
//
//  Created by İlhan Cüvelek on 20.01.2024.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    var settingsOperations = ["Log Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource=self
        tableView.delegate=self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingsOperations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = settingsOperations[indexPath.row]
        content.image = UIImage(systemName: "rectangle.portrait.and.arrow.right.fill")
        cell.tintColor = .secondaryLabel
        cell.contentConfiguration = content
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toVC", sender: nil)
        }catch{
            print("error")
        }
    }

}
