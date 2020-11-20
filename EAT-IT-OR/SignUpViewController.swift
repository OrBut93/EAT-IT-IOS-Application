//
//  SignUpViewController.swift
//  EAT-IT-Project
//
//  Created by admin on 02/07/2020.
//  Copyright © 2020 Or. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pswField: UITextField!
    @IBOutlet weak var registerbtn: UIButton!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var msg: UILabel!
//    @IBOutlet weak var imageView: UIImageView!
//    @IBOutlet weak var addPicbtn: UIButton!
    
    
   override func viewDidLoad(){
            super.viewDidLoad()
            
            activity.isHidden = true
            pswField.isSecureTextEntry = true
            msg.alpha = 0
        }
        
        override func viewDidAppear(_ animated: Bool){
            super.viewDidAppear(animated);
            
          
            if(Model.instance.isLoggedIn()){
                self.navigationController?.popToRootViewController(animated: true)
            }
        }

//        var selectedImage:UIImage?
//
//    @IBAction func addImage(_ sender: Any) {        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
//            imagePicker.allowsEditing = true
//            self.present(imagePicker, animated: true, completion: nil)
//        }
//
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage;
//        self.imageView.image = selectedImage;
//        dismiss(animated: true, completion: nil);
//    }
//

        @IBAction func register(_ sender: UIButton){
            print("register btn")
////            addPicbtn.isEnabled = false
            registerbtn.isHidden = true
            activity.isHidden = false
            msg.isHidden = true

            validateFields(){ (error) in
                if error != "" {
                    self.showMsg(error!)
                    self.activity.isHidden = true
                    self.registerbtn.isHidden = false
////                    self.addPicbtn.isEnabled = true
                }
                else{
                    let user = User(name: self.nameField.text!, email: self.emailField.text!, psw: self.pswField.text!)
                        Model.instance.register(user:user){(success) in
                                if (success) {
                                    self.activity.isHidden = true
                                    self.registerbtn.isHidden = false
                                    self.navigationController?.popToRootViewController(animated: true)
                                    
                                }
                                    
                                else{
                                    self.showMsg("Registration failed")
                                }
                            }
                    
                            return
//                        }

//                    Model.instance.saveImage(image: selectedImage) {(url) in
//                        new_user.avatar = url
//                        self.regAddition(user: new_user)
//                    }
                }
            }
            
        }
        
        func regAddition(user:User){
            Model.instance.register(user:user){(success) in
                if (success) {
                    self.activity.isHidden = true
                    self.registerbtn.isHidden = false
                    self.navigationController?.popToRootViewController(animated: true)
                }
                else{
                    self.showMsg("Registration failed")
                }
            }
        }
        
        func validateFields(callback: @escaping (String?) -> Void){
            if nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                pswField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                callback("Please fill in all fields")
            }
            
            let emailCheck = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
            if !emailCheck.evaluate(with: emailField.text){
                callback("Invalid email address")
            }
            
            let passwordCheck = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
            if !passwordCheck.evaluate(with: pswField.text){
               callback("Check your password contains 8 digits, at least one upper case and one lower case")
            }

            callback("")
        }
        
        func showMsg(_ message:String) -> Void {
            DispatchQueue.main.async {
                let alertController = UIAlertController (title: "error", message: message, preferredStyle: .alert)
                
                let OkAction = UIAlertAction (title : "OK", style: .default){
                    (action: UIAlertAction!) in
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                alertController.addAction(OkAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
    }
