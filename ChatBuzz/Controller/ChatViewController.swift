//
//  ChatViewController.swift
//  ChatBuzz
//
//  Created by Ahmed Amr on 5/16/18.
//  Copyright © 2018 Ahmed Amr. All rights reserved.


import UIKit
import Firebase
import ChameleonFramework
import SVProgressHUD
import AVFoundation


class ChatViewController: UIViewController, UITableViewDelegate , UITableViewDataSource , UITextFieldDelegate {

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    
    var imagePassedOver : UIImage?
    let  senderSound = try! AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "SenderSound", ofType: "wav")!))
    let receiverSound = try! AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "ReceiverSound", ofType: "wav")!))
    
    var messageArray : [Message] = [Message] ()
    var messageArray2 : [Message] = [Message] ()
    let intArray : [Int] = [Int] ()
   
    override func viewDidLoad() {
        super.viewDidLoad()
     messageArray2 = messageArray
     messageTableView.delegate = self
     messageTableView.dataSource = self
     messageTextField.delegate = self
        
      
        let imageView = UIImageView(image: UIImage(named: "background"))
        imageView.contentMode = .scaleAspectFill
        messageTableView.backgroundView = imageView

       
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        retrieveMessages()
         messageTableView.separatorStyle = .none
    
        // Do any additional setup after loading the view.
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        SVProgressHUD.show(withStatus: "logging out")
        do {
        try Auth.auth().signOut()
            navigationController?.popViewController(animated: true)
            SVProgressHUD.show(UIImage(named: "sad")!, status: "Bye")
            SVProgressHUD.dismiss(withDelay: 0.8)
             let vc = LoginViewController()
             vc.passwordTextField!.text = ""
            
        } catch
        {
            SVProgressHUD.showError(withStatus: "Error logging out")
        }
    }
    
 
    @IBAction func sendButtonPressed(_ sender: UIButton) {
            messageTextField.endEditing(true)
        messageTextField.isEnabled = false
        sendButton.isEnabled = false
        let messagesDB = Database.database().reference().child("Messages")
        let messageDict = ["Sender": Auth.auth().currentUser?.email , "MessageBody": messageTextField.text!]
        messagesDB.childByAutoId().setValue(messageDict){
            (error, reference) in
                if error != nil {
                    print(error!)
                } else {
                    print("Message saved")
                    self.messageTextField.isEnabled = true
                    self.sendButton.isEnabled = true
                    self.messageTextField.text = ""
                    self.senderSound.play()
               
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        cell.backgroundColor = .clear
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String? {
            
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.avatarImageView.image = #imageLiteral(resourceName: "egg.png")
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
            cell.messageBackground.transform = CGAffineTransform(translationX: 0 , y: 0)
            cell.avatarImageView.transform = CGAffineTransform(translationX: 0 , y: 0)
        } else {
            cell.avatarImageView.image = #imageLiteral(resourceName: "egg.png")
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
            cell.messageBackground.transform = CGAffineTransform(translationX: ((cell.avatarImageView.frame.width + cell.messageBody.frame.width) - cell.frame.size.width )/1.16 , y: 0)
            cell.avatarImageView.transform = CGAffineTransform(translationX: ((cell.avatarImageView.frame.width + cell.messageBody.frame.width) - cell.frame.size.width )/1.16 , y: 0)
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func configureTableView() {
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
       
    }
   
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3){
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func tableViewTapped (){
        messageTextField.endEditing(true)
    }
    
    func retrieveMessages(){
        
        let messageDB = Database.database().reference().child("Messages")
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            let message = Message()
            message.messageBody = text
            message.sender = sender
            let messageArraySize = self.messageArray.count
            self.messageArray.append(message)
            if messageArraySize != self.messageArray.count && message.messageBody != "" && message.sender != "" && message.sender != Auth.auth().currentUser?.email as String?  {
                self.receiverSound.play()
            }
            self.configureTableView()
            self.messageTableView.reloadData()
            self.scrollToBottom()
        }
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messageArray.count-1, section: 0)
            self.messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
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
