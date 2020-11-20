//
//  Model.swift
//  EAT-IT-Project
//
//  Created by admin on 07/06/2020.
//  Copyright © 2020 Or. All rights reserved.
//

import Foundation
import UIKit

class Model {
    
    static let instance = Model()
        
        var modelFirebase:ModelFirebase = ModelFirebase()
        var modelFirebaseStorage: FirebaseStorage = FirebaseStorage()
        
        var loggedIn = false
    
    func changelog() {
        self.loggedIn = true;
    }
        
    
        private init(){
            loggedIn = modelFirebase.isLoggedIn()
        }
        
        func getCurrentUserId() -> String{
            return modelFirebase.getCurrentUserId()
        }
        
        func getCurrentUserName () -> String{
            return modelFirebase.getCurrentUserName()
        }
        
        func getCurrentUserAvatar () -> String{
            return modelFirebase.getCurrentUserAvatar()
        }
        
        func upsertRecommend(recommend:Recommend){
            modelFirebase.upsertRecommend(recommend: recommend);
        }
        
        func deleteRecommend(recommend:Recommend){
            modelFirebase.deleteRecommend(recommend: recommend);
            recommend.deleteFromDb()
        }
        
        func getUserRecommend(callback:@escaping ([Recommend]?)->Void){
            let finalData = Recommend.getUserRecommendFromDb(uid: self.getCurrentUserId())
            callback(finalData);
        }
        
        func getAllRecommend(callback:@escaping ([Recommend]?)->Void){
            let recommendLastUpdate = Recommend.getLastUpdateDate();
            
            modelFirebase.getAllRecommend(since:recommendLastUpdate) { (data) in
                var lastUpdate:Int64 = 0;
                for recommend in data!{
                    recommend.upsertToDb()
                    if recommend.lastUpdate! > lastUpdate {lastUpdate = recommend.lastUpdate!}
                }
                
                Recommend.setLastUpdate(lastUpdated: lastUpdate)
                
                ModelEvents.recommendDataEvent.post();
                
                let finalData = Recommend.getAllRecommendFromDb()
                callback(finalData);
            }
        }
        
        func saveImage(image:UIImage, callback:@escaping (String)->Void) {
            modelFirebaseStorage.saveImage(image: image, callback: callback)
        }
                
        func isLoggedIn()-> Bool {
            return loggedIn
        }
        
        func logIn(email:String, psw:String, callback: @escaping (Bool)->Void){
            modelFirebase.signIn(email: email, psw: psw) {(success) in
                if(success){
                    ModelEvents.LoginStateChangeEvent.post()
                    self.loggedIn = true
                    callback(true)
                }
                else {
                    self.loggedIn = false
                    callback(false)
                }
            }
        }
        
        func logOut(callback: @escaping (Bool)->Void){
            modelFirebase.signOut() {(success) in
                if(success){
                    loggedIn = false
                    callback(true)
                }
                else {
                    loggedIn = true
                    callback(false)
                }
            }
        }
        
        func register(user:User, callback: @escaping (Bool)->Void){
            modelFirebase.registerUser(user: user) {(success) in
                if(success){
                    ModelEvents.LoginStateChangeEvent.post()
                    self.loggedIn = true
                    callback(true)
                }
                else {
                    self.loggedIn = false
                    callback(false)
                    
                }
            }
        }
    }

    //* Handle Events *//

   class ModelEvents{
        
        static let recommendDataEvent = EventNotificationBase(eventName: "or.recommendDataEvent")
        static let LoginStateChangeEvent = EventNotificationBase(eventName: "or.LoginStateChangeEvent")
        private init(){}
    }

    class EventNotificationBase{
        let eventName:String;
        
        init(eventName:String){
            self.eventName = eventName;
        }
        
        func observe(callback:@escaping()-> Void){
            NotificationCenter.default.addObserver(forName: NSNotification.Name(eventName), object:nil, queue:nil){
                (data) in callback();
            }
        }
        
        func post(){
            NotificationCenter.default.post(name: NSNotification.Name(eventName),object: self,userInfo: nil)
        }
    }

//
//
//
//    static let instance = Model()
//
//    var modelFirebase:ModelFirebase = ModelFirebase()
//    var firebaseStorage:FirebaseStorage = FirebaseStorage()
//
//    var loggedIn = false
//
//    private init(){
//
//       loggedIn = modelFirebase.isLoggedIn()
//    }
//
//    func getCurrentUserId() -> String{
//        return modelFirebase.getCurrentUserId()
//    }
//
//    func getCurrentUserName () -> String{
//        return modelFirebase.getCurrentUserName()
//    }
//
//    func getCurrentUserAvatar () -> String{
//        return modelFirebase.getCurrentUserAvatar()
//    }
//
//    func upsertRecommend(recommend:Recommend){
//        modelFirebase.upsertRecommend(recommend: recommend);
//    }
//
//    func deleteRecommend(recommend:Recommend){
//        modelFirebase.deleteRecommend(recommend: recommend);
//        recommend.deleteFromDb()
//    }
//
//    func getUserRecommend(callback:@escaping ([Recommend]?)->Void){
//        let finalData = Recommend.getUserRecommendFromDb(uid: self.getCurrentUserId())
//        callback(finalData);
//    }
//
//    func getAllRecommend(callback:@escaping([Recommend]?)->Void){
//
//        //get the local last update date
//        let lud = Recommend.getLastUpdateDate();
//
//        //get the records from firebase since the local last update date
//        modelFirebase.getAllRecommend(since:lud) { (data) in
//
//            //save the new record to the local db
//            var lastUpdate: Int64 = 0;
//            for rec in data!{
//                rec.upsertToDb()
//                if rec.lastUpdate! > lastUpdate
//                {
//                    lastUpdate = rec.lastUpdate!
//                }
//            }
//            //update the recommend local last update date
//
//            Recommend.setLastUpdate(lastUpdated: lastUpdate)
//            ModelEvents.recommendDataEvent.post();
//            // get the complete recommend list
//            let finalData = Recommend.getAllRecommendFromDb()
//            callback(finalData);
//        }
//    }
//
//    func saveImage(image:UIImage, callback:@escaping (String)-> Void) {
//        firebaseStorage.saveImage(image: image, callback: callback)
//    }
//
//    func isLoggedIn()-> Bool {
//        return loggedIn
//    }
//
//    func logIn(email:String, pwd:String, callback: @escaping (Bool)->Void){
//        modelFirebase.signIn(email: email, pwd: pwd) {(success) in
//            if(success){
//                ModelEvents.LoginStateChangeEvent.post()
//                self.loggedIn = true
//                callback(true)
//            }
//            else {
//                self.loggedIn = false
//                callback(false)
//            }
//        }
//    }
//
//    func logOut(callback: @escaping (Bool)->Void){
//        modelFirebase.signOut() {(success) in
//            if(success){
//                loggedIn = false
//                callback(true)
//            }
//            else {
//                loggedIn = true
//                callback(false)
//            }
//        }
//    }
//
//    func register(user:User, callback: @escaping (Bool)->Void){
//        modelFirebase.registerUser(user: user) {(success) in
//            if(success){
//                ModelEvents.LoginStateChangeEvent.post()
//                self.loggedIn = true
//                callback(true)
//            }
//            else {
//                self.loggedIn = false
//                callback(false)
//
//            }
//        }
//    }
//}
//
//
//class ModelEvents{
//
//    static let recommendDataEvent = EventNotificationBase(eventName: "or.recommendDataEvent")
//    static let LoginStateChangeEvent = EventNotificationBase(eventName: "or.LoginStateChangeEvent")
//    private init(){}
//}
//
//class EventNotificationBase{
//    let eventName:String;
//
//    init(eventName:String){
//        self.eventName = eventName;
//    }
//
//    func observe(callback:@escaping()-> Void){
//        NotificationCenter.default.addObserver(forName: NSNotification.Name(eventName), object:nil, queue:nil){
//            (data) in callback();
//        }
//    }
//
//    func post(){
//        NotificationCenter.default.post(name: NSNotification.Name(eventName),object: self,userInfo: nil)
//    }
//}
//
