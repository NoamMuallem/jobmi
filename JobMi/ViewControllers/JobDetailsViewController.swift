//
//  JobDetailsViewController.swift
//  JobMi
//
//  Created by noam muallem on 15/06/2022.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class JobDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var titleTextFeild: UITextField!
    @IBOutlet weak var priceTextFeild: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var aboutYouTextFeild: UITextView!
    
    var db: Firestore!
    var requests = [Request]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
    }
    
    @IBAction func openToWorkAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "OpenForWorkViewController") as! OpenForWorkViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func signInBtnAction(_ sender: Any) {
        
        // Add a new document in collection "request"
        
        self.showSpinner(onView: self.view);
        db.collection("request").addDocument(data: [
            "title": titleTextFeild.text as Any,
            "price": priceTextFeild.text as Any,
            "about": aboutYouTextFeild.text as Any,
            "uid" : Auth.auth().currentUser!.uid,
            //"id" : randomInt
        ]) { err in
            if let err = err {
                
                print("Error writing document: \(err)")
                self.removeSpinner()
                self.showAlert(title: "Error", message: "Error writing document: \(err)")
            } else {
                
                let refreshAlert = UIAlertController(title: "Success", message: "request successfully uploaded", preferredStyle: UIAlertController.Style.alert)
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    self.removeSpinner()
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "OpenForWorkViewController") as! OpenForWorkViewController
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }))
                self.present(refreshAlert, animated: true, completion: nil)
            }
        }
    }
}
