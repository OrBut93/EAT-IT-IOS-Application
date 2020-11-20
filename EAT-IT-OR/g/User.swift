//
//  User.swift
//  EAT-IT-Project
//
//  Created by admin on 02/07/2020.
//  Copyright © 2020 Or. All rights reserved.
//

import Foundation
import Firebase

class User {
    
    let id:String
    var name:String = ""
    var email:String = ""
    var psw:String = ""
    var avatar:String = ""
    var lastUpdate: Int64?
    
    init(id:String="", name:String, email:String, psw:String){
        self.id = id
        self.name = name
        self.email = email
        self.psw = psw
    }
    
    init(id:String="", name:String, avatar:String=""){
        self.id = id
        self.name = name
        self.avatar = avatar

    }
    
    init(id:String="")
    {
        self.id = id
    }
}
