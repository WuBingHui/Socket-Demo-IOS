//
//  ChatViewController.swift
//  SocketDemo
//
//  Created by Zimi on 2019/5/30.
//  Copyright © 2019 Zimi. All rights reserved.
//

import UIKit

import SocketIO


class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    var message = [NSDictionary]()
    
    var name: String = ""
    
    var isConnected: Bool = true
    
    //目前URL使用Socket.IO官方提供的公開測試連結
    let manager = SocketManager(socketURL: URL(string: "https://socket-io-chat.now.sh")!, config: [.log(false), .compress])
    
    var socket:SocketIOClient!
    
    @IBOutlet weak var buttonSend: UIButton!
    
    @IBOutlet weak var textFieldMessage: UITextField!
    
    
    @IBOutlet weak var tableViewChat: UITableView!
    
    @IBAction func send(_ sender: UIButton) {
        
    //傳送訊息
      attemptSend()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ChatTableViewCell
        
        Cell.labelName.text = "\(message[indexPath.row]["username"] as! String):"
        
        Cell.labelMessage.text = (message[indexPath.row]["message"] as! String)
        
        return Cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonSend.layer.cornerRadius = 3
        buttonSend.layer.borderColor = UIColor.brown.cgColor
        buttonSend.layer.borderWidth = 1
        
        tableViewChat.tableFooterView = UIView()
        
        //初始化Socket
         socket = manager.defaultSocket
       
        //註冊Socket監聽各種事件
        registeredSocket()
    
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    /*
     * 畫面即將要消失
     */
    override func viewWillDisappear(_ animated: Bool) {
        //斷開連線
       socket.disconnect()
    }
    
    /*
     * 畫面已經消失
     */
    override func viewDidDisappear(_ animated: Bool) {
        
        //註銷Socket各種監聽
        unRegisteredSocket()
        
    }
    
    
   /*
     * 該方法用來註冊Socket 各種監聽事件
     */
    func registeredSocket()  {
        
        //登入的監聽 ＆登入監聽閉包的實作
        self.socket.on("login") {[weak self] data, ack in
            
            self!.alert(title:"登入", message: "\(self!.name) 登入成功")
            
        }
        
        //連線的監聽 ＆連線監聽閉包的實作
        self.socket.on("connect") {[weak self] data, ack in
            self!.alert(title:"連線", message: "連線成功")
            //執行新增用戶
            self!.socket.emit("add user", self!.name)
        }
        
         //斷開連線的監聽 ＆斷開連線監聽閉包的實作
        self.socket.on("disconnect") {[weak self] data, ack in
            
            self!.isConnected = false;
            self!.alert(title:"連線", message: "已斷開連線")
        }
        
         //異常連線的監聽 ＆異常連線監聽閉包的實作
        self.socket.on("connect_error") {[weak self] data, ack in
             self!.isConnected = false;
            self!.alert(title:"錯誤訊息", message: "連線異常")
        }
        
         //連線逾時的監聽 ＆連線逾時監聽閉包的實作
        self.socket.on("connect_timeout") {[weak self] data, ack in
             self!.isConnected = false;
            self!.alert(title:"錯誤訊息", message: "連線異常")
        }
        
        //新訊息的監聽 ＆ 新訊息監聽閉包的實作(該監聽只有監聽收訊息，所以本地端發送訊息的table顯示還是要自己寫入tableView)
        //實作addMessage()方法
        
        self.socket.on("new message") {data, ack in
            //實作新訊息
            
            /*
             server定義的回傳格式
             data:
             [{
             message = welcome;
             username = aks;
             }]
             */
           
        
            self.addMessage(respone: data[0] as! NSDictionary)
            
            
        }
        
        //建立連線
        socket.connect()
        
       
        
    }
    //---------
    
    
    /*
     * 該方法用來註銷Socket 各種監聽事件
     */
    func unRegisteredSocket()  {
        
        //註銷登入監聽
        self.socket.off("login")
        
        //註銷連線監聽
        self.socket.off("connect")
        
        //註銷斷開連線監聽
        self.socket.off("disconnect")
        
        //註銷異常連線監聽
        self.socket.off("connect_error")
        
        //註銷ㄊ連線逾時監聽
        self.socket.off("connect_timeout")
        
        //註銷新訊息監聽
        self.socket.off("new message")
        
    }
    //---------
    
    
    func alert(title:String,message:String)  {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK!", style: .default) { (UIAlertAction) in
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    /*
     * 新增訊息
     */
    func addMessage(respone: NSDictionary) {
    
       
            message.append(respone)
            
            tableViewChat.reloadData()
            
            scrollToBottom()
        
      
    }
    //--------
    
    /*
     *  tableView滾至底部
     */
    func scrollToBottom(){
        let indexPath = IndexPath(row: message.count - 1, section: 0)
        tableViewChat.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
    //---------
    
    
    /*
     * 傳送訊息
     */
    func attemptSend()  {
    
        if(!isConnected){return}
        
        if(name == ""){return}
        
        if( textFieldMessage.text == ""){
            alert(title: "警告", message: "訊息請勿空白")
            return
        }
        
        let message:String = textFieldMessage.text!
        textFieldMessage.text = ""
        
        //提交訊息到server
        socket.emit("new message", message)
        
        let respone: NSDictionary = ["message": message , "username": name]
        
        addMessage(respone: respone)
        
    }
    //-----------
    
}
