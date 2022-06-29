//
//  SignUpViewController.swift
//  JobMi
//
//  Created by noam muallem on 15/06/2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var fullNameTextFeild: UITextField!
    @IBOutlet weak var emailTextFeild: UITextField!
    @IBOutlet weak var passwordTextFeild: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        signUp()
    }
    
    @IBAction func backToSignIn(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    
    func signUp(){
        self.showSpinner(onView: self.view);
        let fullNameTextFeild = fullNameTextFeild.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailTextFeild = emailTextFeild.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextFeild.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().createUser(withEmail: emailTextFeild, password: password) { [self] (result, err) in
            if err != nil {
                self.removeSpinner()
                self.showAlert(title: "Error", message: err?.localizedDescription ?? "")
            }
            else {
                let db = Firestore.firestore()
                db.collection("users").addDocument(data: ["fullName" : fullNameTextFeild, "email": emailTextFeild, "uid" : Auth.auth().currentUser?.uid as Any]) { (error) in
                    
                    if error != nil{
                        self.removeSpinner()
                        self.showAlert(title: "Error", message: error?.localizedDescription ?? "")
                    } else {
                        self.removeSpinner()
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true)
                    }
                }
            }
        }
    }
}


extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message:
                                                    message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}
