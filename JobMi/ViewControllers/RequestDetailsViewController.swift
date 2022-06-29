//
//  RequestDetailsViewController.swift
//  JobMi
//
//  Created by noam muallem on 15/06/2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RequestDetailsViewController: UIViewController {
    
    @IBOutlet weak var designationLabel: UILabel!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var jobDetails: UITextView!
    
    var requestTitle:String = "";
    var price:String = "";
    var about:String = "";
    var uid:String = "";
    var id:String = "";
    
    var db: Firestore!
    
    @IBAction func returnToJobsList(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "OpenForWorkViewController") as! OpenForWorkViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designationLabel.text = requestTitle
        rateLabel.text = "\(price)$ Per Hour"
        jobDetails.text = "\(about)"
        db = Firestore.firestore()
    }
    
    @IBAction func submitAction(_ sender: Any) {
        
        db.collection("myrequest").addDocument(data: [
            "name": User.instance.fullName,
            "email": User.instance.email,
            "uid" : uid,
            "requestedId" : id
        ]) { err in
            if let err = err {
                
                print("Error writing document: \(err)")
                self.showAlert(title: "Error", message: "Error writing document: \(err)")
            } else {
                
                let refreshAlert = UIAlertController(title: "Success", message: "Invetation sent successfully", preferredStyle: UIAlertController.Style.alert)
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(refreshAlert, animated: true, completion: nil)
            }
        }
    }
    
}
