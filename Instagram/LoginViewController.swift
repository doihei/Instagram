//
//  LoginViewController.swift
//  Instagram
//
//  Created by 土井大平 on 2017/02/06.
//  Copyright © 2017年 土井大平. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    /// メールアドレステキストフィールド
    @IBOutlet weak var mailAddressTF: UITextField!
    
    /// パスワードテキストフィールド
    @IBOutlet weak var passwardTF: UITextField!
    
    /// アカウント名テキストフィールド
    @IBOutlet weak var accountNameTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// ログインボタン押下時アクション
    ///
    /// - Parameter sender: ボタン
    @IBAction func onLogin(_ sender: UIButton) {
    }
    
    /// アカウント作成ボタン押下時アクション
    ///
    /// - Parameter sender: ボタン
    @IBAction func onCreateAccount(_ sender: UIButton) {
    }
}
