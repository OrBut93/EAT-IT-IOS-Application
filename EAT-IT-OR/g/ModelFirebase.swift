//
//  ModelFirebase.swift
//  EAT-IT-Project
//
//  Created by admin on 08/06/2020.
//  Copyright © 2020 Or. All rights reserved.
//

import Foundation
import Firebase

class ModelFirebase {
    
    lazy var db = Firestore.firestore()
    
    func getCurrentUserId() -> String{
        return Auth.auth().currentUser?.uid ?? ""
    }
    
    func getCurrentUserName() -> String{
        return Auth.auth().currentUser?.displayName ?? ""
    }
    func getCurrentUserAvatar() -> String{
        return Auth.auth().currentUser?.photoURL?.absoluteString ?? ""
    }
    
    func isLoggedIn() -> Bool {
        return (Auth.auth().currentUser) != nil
    }
    
    func registerUser(user:User, callback: @escaping (Bool)->Void){
        var error=""
        Auth.auth().createUser(withEmail: user.email, password: user.psw){ (result,err) in
            if err != nil { error = "Error creating user" }
            else {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = user.name
                changeRequest?.commitChanges { (err) in
                    if err != nil { error = "Error creating user" }
                    error != "" ? callback(false) : callback(true)
                }
            }
        }
    }
    
    func signIn(email:String, psw:String, callback: @escaping (Bool)->Void){
        var error=""
        Auth.auth().signIn(withEmail: email, password: psw) {
            (result, err) in
            if let err = err { error = err.localizedDescription }
            error != "" ? callback(false) : callback(true)
        }
    }
    
    func signOut(callback:(Bool)->Void){
        var error=""
        do {
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
            error = "Error signing out"
        }
        error != "" ? callback(false) : callback(true)
    }
    
    func upsertRecommend(recommend:Recommend){
        recommend.id.isEmpty ? addRec(recommend: recommend) : updateRecommend(recommend: recommend)
    }
    

    func addRec(recommend:Recommend){

        // Add a new document with a generated ID
//        var ref: DocumentReference? = nil
        let json = recommend.toJson();
        db.collection("recommendations").addDocument(data: json){
            err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func updateRecommend(recommend:Recommend){
        let json = recommend.toJson();
        
        db.collection("recommendations").document(recommend.id).setData(json){
            err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func deleteRecommend(recommend:Recommend){
        db.collection("recommendations").document(recommend.id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    //TODO:complete since implemantation
    func getAllRecommend(since:Int64, callback: @escaping ([Recommend]?)->Void){
        
        db.collection("recommendations").order(by: "lastUpdate").start(at: [Timestamp(seconds: since, nanoseconds: 0)]).addSnapshotListener{(querySnapshot, err) in
        if let err = err
        {
            print("Error getting documents: \(err)")
            callback(nil);
        }
        else
        {
            querySnapshot!.documentChanges.forEach { rc in
                if (rc.type == .removed) {
                    var json = rc.document.data()
                    json["id"] = rc.document.documentID
                    let r = Recommend(json: json);
                    r.deleteFromDb()
                }
            }
            
            var data = [Recommend]();
            for document in querySnapshot!.documents {
                if !document.metadata.hasPendingWrites {
                    var json = document.data()
                    json["id"] = document.documentID
                    data.append(Recommend(json: json));
                }
            }
            callback(data);
        }
        }
    }
}
