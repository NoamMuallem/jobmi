//
//  MyRequestsViewController.swift
//  JobMi
//
//  Created by noam muallem on 15/06/2022.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class MyRequestsViewController: UIViewController {
    
    @IBOutlet weak var requestTV: UITableView!
    var db: Firestore!
    
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestTV.delegate = self
        requestTV.dataSource = self
        
        db = Firestore.firestore()
        getRequests()
    }
    
    @IBAction func navigateBackToAllJobs(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "OpenForWorkViewController") as! OpenForWorkViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func getRequests() {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("myrequest").whereField("uid", isEqualTo: userUid)
            .getDocuments() { [self] (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    items.removeAll()
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let email = data["email"] ??  ""
                        let name = data["name"] ??  ""
                        let id = document.documentID
                        let item = Item(email: email as! String, name: name as! String,id: id)
                        items.append(item)
                    }
                    self.requestTV.reloadData()
                }
            }
    }
    
}

extension MyRequestsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = requestTV.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RequestTableViewCell
        cell.nameLabel.text = items[indexPath.row].email
        cell.titleLabel.text = items[indexPath.row].name
        cell.email = items[indexPath.row].email
        cell.cellDelegate = self
        cell.id = items[indexPath.row].id;
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
}

//so we can send self as the cellDelegate
extension MyRequestsViewController : TableCellPressDelegate {
    func didPressButton(_ tag: String) {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("myrequest").whereField("uid", isEqualTo: userUid).getDocuments { (querySnapshot, error) in
            if error != nil {
                print(error!)
                
            } else {
                for document in querySnapshot!.documents {
                    if document.documentID == tag {
                        document.reference.delete()
                        
                        self.getRequests()
                    }
                    
                }
                
            }
        }
    }
    
    func displayAlert(_ title: String, _ msg: String) {
        let alertController = UIAlertController(title: title, message:msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}
