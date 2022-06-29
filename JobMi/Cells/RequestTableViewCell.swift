//
//  RequestTableViewCell.swift
//  JobMi
//
//  Created by noam muallem on 16/06/2022.
//

protocol TableCellPressDelegate : class {
    func didPressButton(_ tag: String)
    func displayAlert(_ title: String, _ msg:String)
}

import UIKit

class RequestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    weak var cellDelegate: TableCellPressDelegate?
    var id = "";
    var email = "";
    
    @IBAction func email(_ sender: Any) {
        //for openning the email app with invite email
        //if let url = URL(string: "mailto:\(email)") {
        //  if #available(iOS 10.0, *) {
        //    UIApplication.shared.open(url)
        //  } else {
        //    UIApplication.shared.openURL(url)
        //  }
        //}
        
        //copping to clipboard instead
        UIPasteboard.general.string = email
        cellDelegate?.displayAlert("sucess" ,"coppyed to clipboard seucessfully");
    }
    
    @IBAction func deleteInvite(_ sender: Any) {
        cellDelegate?.didPressButton(id)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
