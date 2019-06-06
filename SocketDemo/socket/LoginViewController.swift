//
//  LoginViewController.swift
//  SocketDemo
//
//  Created by Zimi on 2019/5/30.
//  Copyright © 2019 Zimi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var textFieldName: UITextField!
    
    @IBOutlet weak var buttonLogin: UIButton!
    
    
    @IBOutlet weak var buttonExit: UIButton!
    
    @IBAction func login(_ sender: UIButton) {
    
       
        
        if(textFieldName.text != ""){
            
            //進入聊天室流程
            
            if let controller = storyboard?.instantiateViewController(withIdentifier: "Chat") as? ChatViewController {
                controller.name = (textFieldName.text)!
                present(controller, animated: true, completion: nil)
            }
            
        }else{
         
            alert(title: "警告視窗",message: "名稱勿空白！")
       
        }
        
    
    }
    
    
    @IBAction func exit(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        textFieldName.delegate = self
        
        buttonLogin.layer.cornerRadius = 3
        
        buttonLogin.layer.borderWidth = 1
        
        buttonLogin.layer.borderColor = UIColor.brown.cgColor
        
        buttonExit.layer.cornerRadius = 3
        
        buttonExit.layer.borderWidth = 1
        
        buttonExit.layer.borderColor = UIColor.brown.cgColor
        
        
    }
    

    func alert(title:String,message:String)  {
       
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK!", style: .default) { (UIAlertAction) in
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
}
