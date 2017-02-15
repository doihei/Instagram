//
//  CommentBaseViewController.swift
//  Instagram
//
//  Created by 土井大平 on 2017/02/13.
//  Copyright © 2017年 土井大平. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuth
import FirebaseDatabase

import NextGrowingTextView

import ESTabBarController

/**
 *  登録画面プロトコル
 */
protocol CommentBaseProtcol {
    
    /// キーボードdismissする前に呼ばれる
    ///
    /// - Parameter sender: Notification
    func keyboardWillHideExtension(_ sender: Notification)
    
    /// キーボードdismissする前に呼ばれる(アニメーション後)
    ///
    /// - Parameter sender: Notification
    func keyboardWillHideAnimatedExtension(_ sender: Notification)
    
    /// キーボードappear前に呼ばれる
    ///
    /// - Parameter sender: Notification
    func keyboardWillShowExtension(_ sender: Notification)
    
    /// キーボードappear前に呼ばれる(アニメーション後)
    ///
    /// - Parameter sender: Notification
    func keyboardWillShowAnimatedExtension(_ sender: Notification)
    
    
    /// コメントボタン押下時の処理拡張
    ///
    /// - Parameters:
    ///   - sender: ボタン
    ///   - postData: 投稿データ
    func onCommentExtension(sender: UIButton, postData: PostData, comment: String)
}


/// コメント記入欄がある画面の親VC
class CommentBaseViewController: UIViewController, CommentBaseProtcol {

    /// コメントビュー
    @IBOutlet weak var commentView: UIView!
    
    /// コメントテキストビュー
    @IBOutlet weak var commentTextView: NextGrowingTextView!
    
    /// コメントボタン
    @IBOutlet weak var commentButton: UIButton!
    
    /// コメント下部のAutoLayout
    @IBOutlet weak var commentViewBottom: NSLayoutConstraint!
    
    /// コメントする該当投稿データ
    var postData: PostData? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /// コメント設定
        NotificationCenter.default.addObserver(self, selector: #selector(CommentBaseViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CommentBaseViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        /// コメントテキストビュー設定
        self.commentTextView.layer.cornerRadius = 4
        self.commentTextView.backgroundColor = UIColor.white
        self.commentTextView.textContainerInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        self.commentTextView.placeholderAttributedText = NSAttributedString(string: "コメントを入力してください。",
                                                                            attributes: [NSFontAttributeName: self.commentTextView.font!,
                                                                                         NSForegroundColorAttributeName: UIColor.gray
            ]
        )

        // コメントアクション設定
        self.commentButton.addTarget(self, action: #selector(onComment(sender:event:)), for: .touchUpInside)
    }
    
    /// キーボード監視メソッドWillHide
    ///
    /// - Parameter sender: Notification
    func keyboardWillHide(_ sender: Notification) {
        if let userInfo = (sender as NSNotification).userInfo {
            if let _ = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                self.commentViewBottom.constant = 0
                keyboardWillHideExtension(sender)
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                    self.keyboardWillHideAnimatedExtension(sender)
                })
            }
        }
    }
    
    /// キーボード監視メソッドWillShow
    ///
    /// - Parameter sender: Notification
    func keyboardWillShow(_ sender: Notification) {
        if let userInfo = (sender as NSNotification).userInfo {
            if let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                self.commentViewBottom.constant = keyboardHeight
                keyboardWillShowExtension(sender)
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.keyboardWillShowAnimatedExtension(sender)
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    /// キーボードdismissする前に呼ばれる
    ///
    /// - Parameter sender: Notification
    func keyboardWillHideExtension(_ sender: Notification){}
    
    /// キーボードdismissする前に呼ばれる(アニメーション後)
    ///
    /// - Parameter sender: Notification
    func keyboardWillHideAnimatedExtension(_ sender: Notification){}
    
    /// キーボードappear前に呼ばれる
    ///
    /// - Parameter sender: Notification
    func keyboardWillShowExtension(_ sender: Notification){}
    
    /// キーボードappear前に呼ばれる(アニメーション後)
    ///
    /// - Parameter sender: Notification
    func keyboardWillShowAnimatedExtension(_ sender: Notification){}
    
    /// コメントボタン押した時に呼ばれる
    ///
    /// - Parameters:
    ///   - sender: ボタン
    ///   - event: イベント
    func onComment(sender: UIButton, event:UIEvent){
        
        guard let data = self.postData else { return }
        guard let commentText = self.commentTextView.text, !commentText.isEmpty else { return }
        
        // Firebaseに保存するデータの準備
        if let uid = FIRAuth.auth()?.currentUser?.uid, let name = FIRAuth.auth()?.currentUser?.displayName {
            // 時間
            let time = Date.timeIntervalSinceReferenceDate
        
            // コメントに追加
            data.comments.append(Comment(id: uid, name: name, comment: commentText, date: Date(timeIntervalSinceReferenceDate: time)))
            
            // 辞書型配列にして返す
            var comments: [[String:String]] = []
            for comment in data.comments {
                comments.append(comment.toDictionary())
            }
            
            // 増えたコメントをFirebaseに保存する
            let postRef = FIRDatabase.database().reference().child(Const.PostPath).child(data.id!)
            let commentsDict = ["comments": comments]
            postRef.updateChildValues(commentsDict)
            
            // 空に戻して、キーボードを下げる
            commentTextView.text = ""
            self.view.endEditing(true)
        }
        
        // 処理拡張へ
        onCommentExtension(sender: sender, postData: data, comment: commentText)
    }
    
    /// コメントボタン押下時の処理拡張
    ///
    /// - Parameters:
    ///   - sender: ボタン
    ///   - postData: 投稿データ
    func onCommentExtension(sender: UIButton, postData: PostData, comment: String) {}
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
