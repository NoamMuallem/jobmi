//
//  OpenForWorkViewController.swift
//  JobMi
//
//  Created by noam muallem on 15/06/2022.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class OpenForWorkViewController: UIViewController {
    
    @IBOutlet weak var openToWorkTV: UITableView!
    var requests = [Request]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openToWorkTV.delegate = self
        openToWorkTV.dataSource = self
        
        getRequests()
        
    }
    @IBAction func logOut(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
        catch{
            let alert =  UIAlertController(title: "Error", message: "already logged out", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: .none))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func navigateToMyOffers(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MyREquestsViewController") as! MyRequestsViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        
    }
    
    @IBAction func navigateToAddJob(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "JobDetailsViewController") as! JobDetailsViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        
    }
    func getRequests() {
        
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("request").getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                requests.removeAll()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let requestUid = "\(data["uid"] ?? "")"
                    if (requestUid != userUid) {
                        let title = data["title"] ??  ""
                        let price = data["price"] ??  ""
                        let about = data["about"] ??  ""
                        let uid = data["uid"] ??  ""
                        let id = document.documentID
                        let req = Request(title: title as? String ?? "" , price: price as? String ?? "", about: about as? String ?? "", uid: uid as? String ?? "", id : id)
                        requests.append(req)
                    }
                }
                self.openToWorkTV.reloadData()
            }
        }
    }
    
}
extension OpenForWorkViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = openToWorkTV.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OpenToWorkTableViewCell
        cell.nameLabel.text = requests[indexPath.row].title
        cell.titleLabel.text = requests[indexPath.row].about
        cell.hourlyRateLabel.text = requests[indexPath.row].price
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "RequestDetailsViewController") as! RequestDetailsViewController
        vc.modalPresentationStyle = .fullScreen
        vc.requestTitle=requests[indexPath.row].title
        vc.price=requests[indexPath.row].price
        vc.about=requests[indexPath.row].about
        vc.uid=requests[indexPath.row].uid
        vc.id=requests[indexPath.row].id
        present(vc, animated: true)
        
    }
}

