//
//  LoginViewController.swift
//  Instagram
//
//  Created by 土井大平 on 2017/02/06.
//  Copyright © 2017年 土井大平. All rights reserved.
//

import UIKit

// Firebase系
import Firebase
import FirebaseAuth

// SVProgressHUD系
import SVProgressHUD

class LoginViewController: UIViewController {
    
    /// メールアドレステキストフィールド
    @IBOutlet weak var mailAddressTF: UITextField!
    
    /// パスワードテキストフィールド
    @IBOutlet weak var passwordTF: UITextField!
    
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
        guard let address = mailAddressTF.text else { return }
        guard let password = passwordTF.text else { return }
        guard let accountName = accountNameTF.text else { return }
        
        // 空文字判定
        if address.characters.isEmpty ||
            password.characters.isEmpty ||
            accountName.characters.isEmpty {
            NSLog("DEBUG_PRINT: 何かが空文字です")
            return
        }
        
        // ローディング
        SVProgressHUD.show()
        
        // ログイン処理
        FIRAuth.auth()?.signIn(withEmail: address, password: password) { (user, error) in
            
            if let error = error {
                SVProgressHUD.showError(withStatus: error.localizedDescription)
                print("DEBUG_PRINT: " + error.localizedDescription)
                return
            } else {
                SVProgressHUD.dismiss()
                print("DEBUG_PRINT: ログインに成功しました。")
                
                // 画面を閉じてViewControllerに戻る
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    /// アカウント作成ボタン押下時アクション
    ///
    /// - Parameter sender: ボタン
    @IBAction func onCreateAccount(_ sender: UIButton) {
        guard let address = mailAddressTF.text else { return }
        guard let password = passwordTF.text else { return }
        guard let accountName = accountNameTF.text else { return }
        
        // 空文字判定
        if address.characters.isEmpty ||
            password.characters.isEmpty ||
            accountName.characters.isEmpty {
            NSLog("DEBUG_PRINT: 何かが空文字です")
            return
        }
        
        SVProgressHUD.show()
        // アドレスとパスワードでアカウント作成
        FIRAuth.auth()?.createUser(withEmail: address, password: password) { (user, error) in
            
            if let error = error {
                // エラーがあれば、処理抜け
                SVProgressHUD.showError(withStatus: error.localizedDescription)
                NSLog("DEBUG_PRINT: \(error.localizedDescription)")
                return
            }
            
            SVProgressHUD.dismiss()
            // 表示名を作成する
            if let currentUser = FIRAuth.auth()?.currentUser {
                SVProgressHUD.show()
                let changeRequest = currentUser.profileChangeRequest()
                changeRequest.displayName = accountName
                changeRequest.commitChanges { error in
                    SVProgressHUD.dismiss()
                    if let error = error {
                        NSLog("DEBUG_PRINT: " + error.localizedDescription)
                    }
                    NSLog("DEBUG_PRINT: [displayName = \(String(describing: currentUser.displayName))]の設定に成功しました。")
                    
                    
                    // 画面を閉じてViewControllerに戻る
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                print("DEBUG_PRINT: displayNameの設定に失敗しました。")
            }
        }
    }
}
