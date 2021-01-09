//
//  UserViewController.swift
//  EAT-IT-OR
//
//  Created by admin on 02/01/2021.
//  Copyright © 2021 Or. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LoginViewControllerDelegate {

    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var recTableView: UITableView!
    
    var data = [Recommend]()

    override func viewDidLoad() {
        super.viewDidLoad()
        recTableView.delegate = self
        recTableView.dataSource = self
        
        ModelEvents.LoginStateChangeEvent.observe {
            self.initUserData()
        }
        
        ModelEvents.recommendDataEvent.observe {
            self.getUserRecommend()
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
        self.recTableView.reloadData()
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
        getUserRecommend()

    }
    
    func clearUserData(){
        self.data = [Recommend]()
        self.recTableView.reloadData()
        self.userName.text = ""
    }
    
    func getUserRecommend(){
    Model.instance.getUserRecommend{(data:[Recommend]?) in
            if data != nil{
                self.data = data!
                self.recTableView.reloadData()
            }
        }
    }
    
    @IBAction func logoutbtn(_ sender: Any) {
        Model.instance.logOut(){(success) in
            if (success) { self.onLogOut() }
        }
    }

    var selectedRec:Recommend?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:RecViewCell = tableView.dequeueReusableCell(withIdentifier: "RecCell", for: indexPath) as! RecViewCell
        
        let rc = data[indexPath.row]
        cell.title.text = rc.title
        cell.location.text = rc.location
        cell.avatarImg.image = UIImage(named: "avatar")
        if (rc.image != ""){
            cell.avatarImg.kf.setImage(with: URL(string: rc.image))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRec = data[indexPath.row]
        performSegue(withIdentifier: "RecInfoSeguefromProfile", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "RecInfoSeguefromProfile"){
            let vc:RecInfoViewController = segue.destination as! RecInfoViewController
            vc.recommend = selectedRec
        }
    }

}
