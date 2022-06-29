//
//  UserClass.swift
//  JobMi
//
//  Created by noam muallem on 28/06/2022.
//

import Foundation

class User {
    
    //singleton user object to use throwout the app
    static let instance = User(fullName: "", email: "", uid: "")
    var fullName : String
    var email : String
    var uid : String
    
    // Initialization
    
    private init(fullName: String, email: String, uid: String) {
        self.fullName = fullName
        self.email = email
        self.uid = uid
    }
}

