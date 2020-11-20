//
//  FirebaseStorage.swift
//  EAT-IT-Project
//
//  Created by admin on 16/06/2020.
//  Copyright © 2020 Or. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FirebaseStorage {

    func saveImage(image:UIImage, callback:@escaping (String)->Void){
        
        let storageRef = Storage.storage().reference(forURL: "gs://eat-it-3fc88.appspot.com")
        let data = image.jpegData(compressionQuality: 0.8)
         let imageRef = storageRef.child(UUID().uuidString)
         let metadata = StorageMetadata()
         metadata.contentType = "image/jpeg"
         imageRef.putData(data!, metadata: metadata) { (metadata, error) in
             if (error != nil) {
                             print("Image not stored: ", error!.localizedDescription)
                             return
                         }
                         imageRef.downloadURL { (url, error) in
                             guard let downloadURL = url else {
                                 return
                             }
                             print("url: \(downloadURL)")
                             callback(downloadURL.absoluteString)
                         }
                     }
                 }
             }

    
