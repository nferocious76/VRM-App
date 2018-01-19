//
//  VRMLoginViewController.swift
//  VRM App
//
//  Created by Neil Francis Hipona on 1/15/18.
//  Copyright © 2018 Neil Francis Hipona. All rights reserved.
//

import Foundation
import UIKit

class VRMLoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTF.text = "david.mckinney@islandenergy.co"
        passwordTF.text = "23GYWHBfzBMgt!"
    }
    
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func loginButton(_ sender: UIButton) {
        
        let username = usernameTF.text!
        let password = passwordTF.text!
        VRMAPI.shared.loginWithUsername(username: username, password: password) { (returnObj, error) in
            
            if let returnObj = returnObj {
                print("LOGIN API: ", returnObj)
                
                UserInfo.shared.idUser = returnObj["idUser"] as? Int
                UserInfo.shared.token = returnObj["token"] as? String

                UserDefaults.standard.setValue(returnObj, forKey: "TokenInfo")
                UserDefaults.standard.synchronize()
                
                self.display()
            }else{
                if let error = error as NSError?, let userInfo = error.userInfo as? [String: String] {
                    self.showAlertWithTitle("Error", message: userInfo["message"] ?? "")
                }else{
                    self.showAlertWithTitle("Error", message: "Unknown error")
                }
            }
        }
    }
    
    @IBOutlet weak var loginAsDemoButton: UIButton!
    @IBAction func loginAsDemoButton(_ sender: UIButton) {
        
        VRMAPI.shared.loginAsDemoUser { (returnObj, error) in
            
            if let returnObj = returnObj {
                print("DEMO API: ", returnObj)
                
                UserInfo.shared.idUser = returnObj["idUser"] as? Int
                UserInfo.shared.token = returnObj["token"] as? String

                UserDefaults.standard.setValue(returnObj, forKey: "TokenInfo")
                UserDefaults.standard.synchronize()
            }else{
                if let error = error as NSError?, let userInfo = error.userInfo as? [String: String] {
                    self.showAlertWithTitle("Error", message: userInfo["message"] ?? "")
                }else{
                    self.showAlertWithTitle("Error", message: "Unknown error")
                }
            }
        }
    }
    
    func showAlertWithTitle(_ title: String?, message: String?) {
        
        let aController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        aController.addAction(action)
        
        present(aController, animated: true, completion: nil)
    }
    
    func display() {
        
        DispatchQueue.main.async {
            let displayVC = self.storyboard?.instantiateViewController(withIdentifier: "VRMDisplayViewController") as! VRMDisplayViewController
            self.navigationController?.pushViewController(displayVC, animated: true)
        }
    }
}
