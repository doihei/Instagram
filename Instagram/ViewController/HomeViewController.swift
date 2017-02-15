//
//  HomeViewController.swift
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

import ESTabBarController

/// タイムライン画面
class HomeViewController: CommentBaseViewController {

    /// テーブルビュー
    @IBOutlet weak var tableView: UITableView!
    
    /// 投稿データ格納配列
    var postArray: [PostData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // テーブルセルタップの無効
        tableView.allowsSelection = false
        
        // キーボード制御
        tableView.keyboardDismissMode = .onDrag
        
        // テーブルビューセルクラスの指定
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = UITableViewAutomaticDimension

        /// この画面では隠しておく
        self.commentView.isHidden = true

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        
        let tabBarController = parent?.parent as! ESTabBarController
        tabBarController.setBarHidden(false, animated: false)
        
        if FIRAuth.auth()?.currentUser != nil {
            // Firebase登録
            setFirebaseObserve()
            
        } else {
            if FirebaseObservingUtil.isEitherObserving() {
                // ログアウトを検出したら、一旦テーブルをクリアしてオブザーバーを削除する。
                // テーブルをクリアする
                postArray = []
                tableView.reloadData()
                // オブザーバーを削除する
                FIRDatabase.database().reference().removeAllObservers()
                // Identifierも全て削除
                FirebaseObservingUtil.removeAllObserving()
            }
        }
    }
    
    /// キーボード監視メソッドWillShowアニメート前
    ///
    /// - Parameter sender: Notification
    override func keyboardWillShowExtension(_ sender: Notification) {
        super.keyboardWillShowExtension(sender)
        let tabBarController = parent?.parent as! ESTabBarController
        tabBarController.setBarHidden(true, animated: false)
        self.commentView.isHidden = false
    }
    
    /// キーボード監視メソッドWillHideアニメート前
    ///
    /// - Parameter sender: Notification
    override func keyboardWillHideAnimatedExtension(_ sender: Notification) {
        super.keyboardWillHideAnimatedExtension(sender)
        let tabBarController = parent?.parent as! ESTabBarController
        tabBarController.setBarHidden(false, animated: false)
        self.commentView.isHidden = true
    }
    
    /// この画面のobserve設定
    private func setFirebaseObserve() {
        // 要素が追加されたらpostArrayに追加してTableViewを再表示する
        if !FirebaseObservingUtil.isObservingEvent(type: .timelineAdded) {
            let postsRef = FIRDatabase.database().reference().child(Const.PostPath)
            FirebaseObservingUtil.setCompleteObserveEvent(type: .timelineAdded,
                                                          identifier:
                postsRef.observe(.childAdded, with: { snapshot in
                    print("DEBUG_PRINT: .childAddedイベントが発生しました。")
                    
                    // PostDataクラスを生成して受け取ったデータを設定する
                    if let uid = FIRAuth.auth()?.currentUser?.uid {
                        let postData = PostData(snapshot: snapshot, myId: uid)
                        self.postArray.insert(postData, at: 0)
                        
                        // TableViewを再表示する
                        self.tableView.reloadData()
                    }
                })
            )
        }
        
        if !FirebaseObservingUtil.isObservingEvent(type: .timelineChanged) {
            let postsRef = FIRDatabase.database().reference().child(Const.PostPath)
            // 要素が変更されたら該当のデータをpostArrayから一度削除した後に新しいデータを追加してTableViewを再表示する
            FirebaseObservingUtil.setCompleteObserveEvent(type: .timelineChanged,
                                                          identifier:
                postsRef.observe(.childChanged, with: { snapshot in
                    print("DEBUG_PRINT: .childChangedイベントが発生しました。")
                    
                    if let uid = FIRAuth.auth()?.currentUser?.uid {
                        // PostDataクラスを生成して受け取ったデータを設定する
                        let postData = PostData(snapshot: snapshot, myId: uid)
                        
                        // 保持している配列からidが同じものを探す
                        var index: Int = 0
                        for post in self.postArray {
                            if post.id == postData.id {
                                index = self.postArray.index(of: post)!
                                break
                            }
                        }
                        
                        // 差し替えるため一度削除する
                        self.postArray.remove(at: index)
                        
                        // 削除したところに更新済みのでデータを追加する
                        self.postArray.insert(postData, at: index)
                        
                        // TableViewの現在表示されているセルを更新する
                        self.tableView.reloadData()
                    }
                })
            )
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    /// テーブルビューセル数
    ///
    /// - Parameters:
    ///   - tableView: テーブルビュー
    ///   - section: セクション
    /// - Returns: セル数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    /// セルの設定
    ///
    /// - Parameters:
    ///   - tableView: テーブルビュー
    ///   - indexPath: インデックスパス
    /// - Returns: セル
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してデータを設定する
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as? PostTableViewCell else { return UITableViewCell() }
        
        // 投稿セット
        cell.setPostData(postArray[indexPath.row], indexPath.row)
        // デリゲートセット
        cell.delegate = self
        
        return cell
    }
    
    /// セルの高さを動的に変更
    ///
    /// - Parameters:
    ///   - tableView: テーブルビュー
    ///   - indexPath: インデックスパス
    /// - Returns: 高さ
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        // Auto Layoutを使ってセルの高さを動的に変更する
        return UITableViewAutomaticDimension
    }
    
    /// セルタップ時の挙動
    ///
    /// - Parameters:
    ///   - tableView: テーブルビュー
    ///   - indexPath: インデックスパス
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルをタップされたら何もせずに選択状態を解除する
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - PostTableViewCellDelegate
extension HomeViewController: PostTableViewCellDelegate {
    
    /// イイネボタン押下時の処理拡張
    ///
    /// - Parameters:
    ///   - sender: ボタン
    ///   - row: ROWナンバー
    func onLikeExtension(_ sender: UIButton, _ row: Int) {
        
        // 配列からタップされたインデックスのデータを取り出す
        let postData = postArray[row]
        
        // Firebaseに保存するデータの準備
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            if postData.isLiked {
                // すでにいいねをしていた場合はいいねを解除するためIDを取り除く
                if let index = postData.likes.index(of: uid) {
                    postData.likes.remove(at: index)
                }
            } else {
                postData.likes.append(uid)
            }
            
            // 増えたlikesをFirebaseに保存する
            let postRef = FIRDatabase.database().reference().child(Const.PostPath).child(postData.id!)
            let likes = ["likes": postData.likes]
            postRef.updateChildValues(likes)
            
        }
    }
    
    /// コメントするボタン押下時の処理拡張
    ///
    /// - Parameters:
    ///   - sender: ボタン
    ///   - row: ROWナンバー
    func onCommentWriteExtension(_ sender: UIButton, _ row: Int) {
        let _ = self.commentTextView.becomeFirstResponder()
        self.postData = self.postArray[row]
    }
    
    /// 投稿詳細ボタン押下時の拡張処理
    ///
    /// - Parameters:
    ///   - sender: ボタン
    ///   - row: ROWナンバー
    func onPostDetailExtension(_ sender: UIButton, _ row: Int) {
        let postDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "PostDetail") as! PostDetailViewController
        postDetailVC.postData = self.postArray[row]
        self.navigationController?.pushViewController(postDetailVC, animated: true)
    }
}
