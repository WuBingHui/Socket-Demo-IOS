//
//  ViewController.swift
//  SocketDemo
//
//  Created by Zimi on 2019/5/30.
//  Copyright © 2019 Zimi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var buttonStart: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        //按鈕圓角
        buttonStart.layer.cornerRadius = 3
        
       //按鈕外寬線出粗度
        buttonStart.layer.borderWidth = 1
        
       //按鈕外寬線顏色
        buttonStart.layer.borderColor = UIColor.brown.cgColor
        
        
    }


}

