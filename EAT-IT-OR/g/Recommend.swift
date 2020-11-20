//
//  Recommend.swift
//  EAT-IT-Project
//
//  Created by admin on 07/06/2020.
//  Copyright © 2020 Or. All rights reserved.
//

import Foundation
import Firebase

class Recommend {
    
    var id:String
    var ownerId:String
    var ownerName:String = ""
    var title:String = ""
    var location:String = ""
    var description:String = ""
    var image:String = ""
    var lastUpdate:Int64?
    
    init(id:String="", ownerId:String){
        self.id = id
        self.ownerId = ownerId
    }
}
