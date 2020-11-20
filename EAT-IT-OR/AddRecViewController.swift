//
//  AddRecViewController.swift
//  EAT-IT-Project
//
//  Created by admin on 08/06/2020.
//  Copyright © 2020 Or. All rights reserved.
//

import UIKit


class AddRecViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var addTitle: UITextField!
    @IBOutlet weak var addLocation: UITextField!
    @IBOutlet weak var addDescription: UITextField!
    @IBOutlet weak var addPhotos: UIButton!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var savebtn: UIButton!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    

    var recommend:Recommend?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activity.isHidden = true;
        addTitle.text = self.addTitle.text
        addLocation.text = recommend?.location
        addDescription.text = recommend?.description
        if (recommend != nil)
        {
            addTitle.text = recommend?.title
            addLocation.text = recommend?.location
            addDescription.text = recommend?.description
            avatar.kf.setImage(with: URL(string: recommend!.image));
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
//         if not logged in: go to login page
        if(!Model.instance.isLoggedIn()){
            let loginuser = LoginViewController.factory()
            loginuser.delegate = self as? LoginViewControllerDelegate
            show(loginuser, sender: self)
        }
    }
    
    func onLoginSuccess() {
    }
    
    func onLoginCancell() {
        self.tabBarController?.selectedIndex = 0;
    }
    var selectedImage: UIImage?;

    
    @IBAction func BtnAddPhoto(_ sender: Any) {
        addPhotos.isEnabled = false;
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self ;
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
       }
        addPhotos.isEnabled = true;
    
    }

    func getString() -> String {
        let random = Int64.random(in: 10_000_00..<10_000_000)
        let hour = Calendar.current.component(.hour, from: Date())
        let newID = "\(hour)" + "\(random)"
    
        return newID
    }
    
    
    @IBAction func BtnSave(_ sender: Any) {
        
        activity.isHidden = false;
        savebtn.isEnabled = false;
        addPhotos.isEnabled = false;
        
        if (recommend == nil){
            recommend = Recommend(ownerId:Model.instance.getCurrentUserId())
            recommend?.ownerName = Model.instance.getCurrentUserName()
        }
        
        recommend?.title = addTitle.text!
        recommend?.location = addLocation.text!
        recommend?.description = addDescription.text!
        
        guard let selectedImage = selectedImage else {
            self.upsertRecommend(recommend: recommend!)
            return;
        }

            Model.instance.saveImage(image: selectedImage) { (url) in
                self.recommend?.image = url;
               self.upsertRecommend(recommend: self.recommend!)
            }
        }
    
    func upsertRecommend(recommend:Recommend){
        Model.instance.upsertRecommend(recommend: recommend)
        self.clear()
        
        if(self.tabBarController?.selectedIndex != 1)
        {
            self.navigationController?.popToRootViewController(animated: true)
        }
        else {
            let rec = (self.tabBarController?.viewControllers![0])! as! UINavigationController
            rec.popToRootViewController(animated: true)
            self.tabBarController?.selectedIndex = 0;
        }
    }
    
    func clear(){
        recommend = nil
        addTitle.text = ""
        addLocation.text = ""
        avatar.image = nil
        selectedImage = nil
        addPhotos.isEnabled = true
        savebtn.isEnabled = true
        activity.isHidden = true
    }
//        else {
//            let alert = UIAlertController(title: "Error", message: "You have to share with us photos :)", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage;
        self.avatar.image = selectedImage;
        dismiss(animated: true, completion: nil)
    }

}
