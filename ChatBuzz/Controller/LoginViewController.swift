//
//  loginViewController.swift
//  ChatBuzz
//
//  Created by Ahmed Amr on 5/16/18.
//  Copyright © 2018 Ahmed Amr. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
