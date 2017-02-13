//
//  CommentBaseViewController.swift
//  Instagram
//
//  Created by 土井大平 on 2017/02/13.
//  Copyright © 2017年 土井大平. All rights reserved.
//

import UIKit

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
    
    /// コメントボタン押した時に呼ばれる
    ///
    /// - Parameters:
    ///   - sender: ボタン
    ///   - event: イベント
    func onComment(sender: UIButton, event:UIEvent)
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
    func onComment(sender: UIButton, event:UIEvent){}
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
