//
//  Recommend+Firebase.swift
//  EAT-IT-Project
//
//  Created by admin on 02/07/2020.
//  Copyright © 2020 Or. All rights reserved.
//

import Foundation
import Firebase

extension Recommend{
    
    convenience init(json:[String:Any]) {
        let id = json["id"] as! String;
        let ownerId = json["ownerId"] as! String;

        self.init(id:id, ownerId:ownerId)
        
        ownerName = json["ownerName"] as! String;
        title = json["title"] as! String;
        location = json["location"] as! String;
        description = json["description"] as! String;
        image = json["image"] as! String;
        let ts = json["lastUpdate"] as! Timestamp
        lastUpdate = ts.seconds
    }

        func toJson() -> [String:Any] {
            var json = [String:Any]();
            json["id"] = id
            json["ownerId"] = ownerId
            json["ownerName"] = ownerName
            json["title"] = title
            json["location"] = location
            json["description"] = description
            json["image"] = image
            json["lastUpdate"] = FieldValue.serverTimestamp()
            return json;
        }
    
}

