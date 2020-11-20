//
//  ProfileViewController.swift
//  EAT-IT-OR
//
//  Created by admin on 04/07/2020.
//  Copyright © 2020 Or. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, LoginViewControllerDelegate {
        

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    var data = [Recommend]()
    override func viewDidLoad() {
        super.viewDidLoad()
        ModelEvents.LoginStateChangeEvent.observe {
            self.initUserData()
        }
        
        ModelEvents.recommendDataEvent.observe {
            //self.getUserRecommend()
        }
        
        initUserData()
        
    }

    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated);
        
        if(!Model.instance.isLoggedIn()){
            let loginVc = LoginViewController.factory()
            loginVc.delegate = self
            show(loginVc, sender: self)
        }
    }
    
    func onLoginSuccess(){
        //self.recTableView.reloadData()
    }
    
    func onLoginCancell(){
        self.tabBarController?.selectedIndex = 0;
    }
    
    func onLogOut(){
        self.tabBarController?.selectedIndex = 0;
        self.clearUserData()
    }
    
    func initUserData(){
        userName.text = Model.instance.getCurrentUserName()
        let userAvatar = Model.instance.getCurrentUserAvatar()
        if userAvatar != "" { avatar.kf.setImage(with: URL(string: userAvatar)) }
        else { avatar.image = UIImage(named: "avatar") }
        
//        getUserRecommend()
    }
    
    func clearUserData(){
        self.data = [Recommend]()
        //self.recTableView.reloadData()
        self.userName.text = ""
        self.avatar.image = nil
    }
    
    @IBAction func logout(_ sender: Any) {
        Model.instance.logOut(){(success) in
            if (success) { self.onLogOut() }
        }
    }
    
}
