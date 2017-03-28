//
//  PostViewController.swift
//  Instagram
//
//  Created by 土井大平 on 2017/02/06.
//  Copyright © 2017年 土井大平. All rights reserved.
//

import UIKit

/// Firebase系
import Firebase
import FirebaseAuth
import FirebaseDatabase

/// SVProgressHUD
import SVProgressHUD

/// 投稿画面
class PostViewController: UIViewController {

    /// データ
    var dataString: String!
    
    /// 投稿タイプ
    var postType: PostType!
    
    /// 画像ビュー
    @IBOutlet weak var postPreviewView: PostPreviewView!
    
    /// TF
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 投稿プレビュー
        self.postPreviewView.preview(dataString: dataString, postType)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /// 投稿ボタン押下時処理
    ///
    /// - Parameter sender: ボタン
    @IBAction func onPost(_ sender: UIButton) {
        
        // postDataに必要な情報を取得しておく
        let time = Date.timeIntervalSinceReferenceDate
        let name = FIRAuth.auth()?.currentUser?.displayName
        
        // 辞書を作成してFirebaseに保存する
        let postRef = FIRDatabase.database().reference().child(Const.PostPath)
        let postData = ["caption": textField.text!, "data": postPreviewView.dataString!, "time": String(time), "name": name!, "post_type": String(PostType.image.rawValue)]
        postRef.childByAutoId().setValue(postData)
        
        // HUDで投稿完了を表示する
        SVProgressHUD.showSuccess(withStatus: "投稿しました")
        
        // 全てのモーダルを閉じる
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    /// キャンセルボタン押下時処理
    ///
    /// - Parameter sender: ボタン
    @IBAction func onCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
