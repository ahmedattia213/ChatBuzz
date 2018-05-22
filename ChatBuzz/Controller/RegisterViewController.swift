//
//  registerViewController.swift
//  ChatBuzz
//
//  Created by Ahmed Amr on 5/16/18.
//  Copyright © 2018 Ahmed Amr. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        SVProgressHUD.show(withStatus: "please wait..")
    
        var flag = true
        if emailTextField.text == "" {
            flag = false
            animateTextField(textField: emailTextField)
            SVProgressHUD.dismiss()
        }
        if passwordTextField.text  == "" {
            flag = false
        animateTextField(textField: passwordTextField)
            SVProgressHUD.dismiss()
        }
        if flag {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!){
            (user,error) in
            
            if error != nil {
                if let errCode = AuthErrorCode(rawValue: (error?._code)!){
                    switch errCode {
                    case .invalidEmail:
                        self.errorLabel.text = "Error: Invalid email format"
                        
                    case.emailAlreadyInUse:
                        self.errorLabel.text = "Error: this email already registered"
                       
                    case.weakPassword:
                         self.errorLabel.text = "Error: please choose a password of at least 6 characters" 
                    default:
                         self.errorLabel.text = "Error: please check your internet connection."
                      
                    }
                    SVProgressHUD.dismiss()
                    self.errorLabel.isHidden = false
                    self.animateLabel(label: self.errorLabel)
                }
              
            } else {
                self.errorLabel.isHidden = true
                SVProgressHUD.dismiss()
                SVProgressHUD.showSuccess(withStatus: "Done")
                SVProgressHUD.dismiss(withDelay: 0.6)
                self.performSegue(withIdentifier: "goToChat", sender: self)
                 
                
              
            }
        }
    }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         errorLabel.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animateTextField(textField : UITextField) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: textField.center.x - 7, y: textField.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: textField.center.x + 7, y: textField.center.y))
        
        textField.layer.add(animation, forKey: "position")
    }
    
    func animateLabel(label : UILabel) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.12
        animation.repeatCount = 1
        animation.autoreverses = true
        
        animation.fromValue = NSValue(cgPoint: CGPoint(x: label.center.x + 25, y: label.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: label.center.x , y: label.center.y))
        
        label.layer.add(animation, forKey: "position")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
