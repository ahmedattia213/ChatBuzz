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

class RegisterViewController: UIViewController , UIImagePickerControllerDelegate
, UINavigationControllerDelegate {

    

    @IBOutlet weak var profImage: UIButton!
    
    @IBOutlet weak var ay7aga: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!

    
 
    

    @IBAction func addProfImagePressed(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            profImage.setImage(editedImage, for: .normal)
            dismiss(animated: true, completion: nil)
        }
      else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            profImage.setImage(originalImage, for: .normal)
            dismiss(animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        SVProgressHUD.show(withStatus: "please wait..")
    
        var flag = true
        if emailTextField.text == "" {
            flag = false
            handleEmptyField(textfield: emailTextField)
        }
        if passwordTextField.text  == "" {
            flag = false
            handleEmptyField(textfield: passwordTextField)
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
                    self.handleErrorForRegister()
                }
              
            } else {
                self.handleSuccessForRegister()
                
              
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
    func handleErrorForRegister(){
        SVProgressHUD.dismiss()
        self.errorLabel.isHidden = false
        self.animateLabel(label: self.errorLabel)
    }
    func handleSuccessForRegister(){
        self.errorLabel.isHidden = true
        SVProgressHUD.dismiss()
        SVProgressHUD.showSuccess(withStatus: "Done")
        SVProgressHUD.dismiss(withDelay: 0.6)
        self.performSegue(withIdentifier: "goToChat", sender: self)
    }
    func handleEmptyField(textfield : UITextField){
        animateTextField(textField: emailTextField)
        SVProgressHUD.dismiss()
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
  
    

  

}
