//
//  SettingViewController.swift
//  Instagram
//
//  Created by 土井大平 on 2017/02/06.
//  Copyright © 2017年 土井大平. All rights reserved.
//

import UIKit

// ESTabBarController
import ESTabBarController

// Firebase系
import Firebase
import FirebaseAuth

// SVProgressHUD
import SVProgressHUD

class SettingViewController: UIViewController {

    @IBOutlet weak var accountNameTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 現ユーザーの表示名設定
        if let user = FIRAuth.auth()?.currentUser {
            accountNameTF.text = user.displayName
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /// 表示名を変更ボタン押下時処理
    ///
    /// - Parameter sender: ボタン
    @IBAction func onChangeName(_ sender: UIButton) {
        
        guard let accountName = accountNameTF.text else { return }
        
        // 表示名が入力されていない時はHUDを出して何もしない
        if accountName.characters.isEmpty {
            SVProgressHUD.showError(withStatus: "表示名を入力して下さい")
            return
        }
        
        // 表示名を設定する
        if let user = FIRAuth.auth()?.currentUser {
            let changeRequest = user.profileChangeRequest()
            changeRequest.displayName = accountName
            changeRequest.commitChanges { error in
                if let error = error {
                    print("DEBUG_PRINT: " + error.localizedDescription)
                }
                print("DEBUG_PRINT: [displayName = \(String(describing: user.displayName))]の設定に成功しました。")
                
                // HUDで完了を知らせる
                SVProgressHUD.showSuccess(withStatus: "表示名を変更しました")
            }
        } else {
            print("DEBUG_PRINT: displayNameの設定に失敗しました。")
        }
        // キーボードを閉じる
        self.view.endEditing(true)
    }


    /// ログアウトボタン押下時処理
    ///
    /// - Parameter sender: ボタン
    @IBAction func onLogout(_ sender: UIButton) {
        
        // ログアウトする
        try! FIRAuth.auth()?.signOut()
        
        // ログイン画面を表示する
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(loginViewController!, animated: true, completion: nil)
        
        // ログイン画面から戻ってきた時のためにホーム画面（index = 0）を選択している状態にしておく
        let tabBarController = parent as! ESTabBarController
        tabBarController.setSelectedIndex(0, animated: false)
    }
}
