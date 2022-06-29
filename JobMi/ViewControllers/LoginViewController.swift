//
//  LoginViewController.swift
//  JobMi
//
//  Created by noam muallem on 15/06/2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextFeild: UITextField!
    @IBOutlet weak var passwordTextFeild: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func signInActon(_ sender: Any) {
        self.showSpinner(onView: self.view);
        
        //create clean versions of text fields
        let email = emailTextFeild.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextFeild.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //sign in the user
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil{
                //could not sign in
                self.removeSpinner()
                
                let alert =  UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: .none))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                guard let userUid = Auth.auth().currentUser?.uid else { return }
                Firestore.firestore().collection("users").whereField("uid", isEqualTo: userUid).getDocuments() { [self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                        self.removeSpinner()
                        self.showAlert(title: "Error", message: "\(err.localizedDescription)")
                    } else {
                        for document in querySnapshot!.documents {
                            let data = document.data()
                            guard let email = data["email"] else { return }
                            guard let fullName = data["fullName"] else { return }
                            guard let uid = data["uid"] else { return }
                            
                            User.instance.fullName = fullName as! String
                            User.instance.email = email as! String
                            User.instance.uid = uid as! String
                            
                            self.removeSpinner()
                            let vc = storyboard?.instantiateViewController(withIdentifier: "OpenForWorkViewController") as! OpenForWorkViewController
                            vc.modalPresentationStyle = .fullScreen
                            present(vc, animated: true)
                        }
                    }
                }
            }
        }
        
    }
    
    
    @IBAction func dontAccountAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as! SignUpViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

var vSpinner : UIView?

extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}
