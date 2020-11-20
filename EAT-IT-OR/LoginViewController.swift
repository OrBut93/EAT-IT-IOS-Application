//
//  LoginViewController.swift
//  EAT-IT-Project
//
//  Created by admin on 02/07/2020.
//  Copyright © 2020 Or. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate {
    func onLoginSuccess();
    func onLoginCancell();
}

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pswField: UITextField!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var loginbtn: UIButton!
    @IBOutlet weak var msg: UILabel!
    
    static func factory()->LoginViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginViewController")
    }
    var delegate:LoginViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        msg.alpha = 0
        activity.isHidden = true
        pswField.isSecureTextEntry = true
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated);
        
        if(Model.instance.isLoggedIn()){
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @objc func back(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
        if let delegate = delegate {
            delegate.onLoginCancell()
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
        loginbtn.isHidden = true
        activity.isHidden = false
        msg.isHidden = true
        
        validateFields(){ (error) in
            if error != ""{
                self.showMsg(error!)
                self.activity.isHidden = true
                
            }
            else{
                Model.instance.logIn(email: self.emailField.text!, psw: self.pswField.text!){ (success) in
                    
                    if(success){
                        //go back when the user logged in
                        self.navigationController?.popToRootViewController(animated: true)
                        if let delegate = self.delegate{
                            delegate.onLoginSuccess()
                        }
                    }
                    else{
                        self.showMsg("Login failed")
                    }
                    
                    self.loginbtn.isHidden = false
                    self.activity.isHidden = true
                }
            }
        }
    }
    
    func validateFields(callback: @escaping (String?) -> Void){
        if emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            pswField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            callback("Please fill in all fields")
        }
        else {callback("")}
    }
    
    
    func showMsg(_ message:String){
        msg.isHidden = false
        msg.text = message
        msg.alpha = 1
        loginbtn.isHidden = false
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
