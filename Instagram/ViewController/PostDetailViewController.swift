//
//  PostDetailViewController.swift
//  Instagram
//
//  Created by 土井大平 on 2017/02/13.
//  Copyright © 2017年 土井大平. All rights reserved.
//

import UIKit
import ESTabBarController

/// Firebase系
import Firebase
import FirebaseAuth
import FirebaseDatabase

/// 投稿詳細セルタイプ
///
/// - detail: 詳細
/// - comment: コメント
private enum PostDetailCellType: Int {
    case detail
    case comment
    
    /// タイプ数返却
    static var count: Int {
        var i = 0
        while let _ = PostDetailCellType(rawValue: i) { i += 1 }
        return i
    }
}

/// 投稿詳細画面
class PostDetailViewController: CommentBaseViewController {

    /// 該当投稿データ
    var postData: PostData?
    
    /// テーブルビュー
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // テーブルセルタップの無効
        tableView.allowsSelection = false
        
        // キーボード制御
        tableView.keyboardDismissMode = .onDrag
        
        // 投稿詳細セル
        let postTableViewCellNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(postTableViewCellNib, forCellReuseIdentifier: "PostTableViewCell")
        
        // コメント一覧セル
        let commentTableViewCellNib = UINib(nibName: "CommentTableViewCell", bundle: nil)
        tableView.register(commentTableViewCellNib, forCellReuseIdentifier: "CommentTableViewCell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // タブ隠しておく
        let tabBarController = parent?.parent as! ESTabBarController
        tabBarController.setBarHidden(true, animated: false)
        
        if FIRAuth.auth()?.currentUser != nil {
            
            if FirebaseObservingUtil.isObservingEvent(type: .postDetailChanged) {
                // 設定されていた場合、削除して登録し直し
                if let identifier = FirebaseObservingUtil.getObservingIdentifier(type: .postDetailChanged) {
                    FIRDatabase.database().reference().child(Const.PostPath).removeObserver(withHandle: identifier)
                    FirebaseObservingUtil.removeObserving(type: .postDetailChanged)
                    setFirebaseObserve()
                }
            } else {
                // そのまま登録
                setFirebaseObserve()
            }
        } else {
            if FirebaseObservingUtil.isEitherObserving() {
                // ログアウトを検出したら、一旦テーブルをクリアしてオブザーバーを削除する。
                // テーブルをクリアする
                self.postData = nil
                tableView.reloadData()
                // オブザーバーを削除する
                FIRDatabase.database().reference().removeAllObservers()
                // ID保持も初期化
                FirebaseObservingUtil.removeAllObserving()
                
                // FIRDatabaseのobserveEventが上記コードにより解除されたため
                let _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let identifier = FirebaseObservingUtil.getObservingIdentifier(type: .postDetailChanged) {
            // 削除
            FIRDatabase.database().reference().child(Const.PostPath).removeObserver(withHandle: identifier)
            FirebaseObservingUtil.removeObserving(type: .postDetailChanged)
        }
    }
    
    /// この画面のobserve設定
    private func setFirebaseObserve() {
        // こいつはObserve保持しない
        let postsRef = FIRDatabase.database().reference().child(Const.PostPath)
        // 要素が変更されたら該当のデータをpostArrayから一度削除した後に新しいデータを追加してTableViewを再表示する
        FirebaseObservingUtil.setCompleteObserveEvent(type: .postDetailChanged,
                                                      identifier:
            postsRef.observe(.childChanged, with: { snapshot in
                print("DEBUG_PRINT: .childChangedイベントが発生しました。")
                
                if let uid = FIRAuth.auth()?.currentUser?.uid {
                    // PostDataクラスを生成して受け取ったデータを設定する
                    let postData = PostData(snapshot: snapshot, myId: uid)
                    
                    // 保持しているデータからidが同じものがあれば変更
                    if self.postData?.id == postData.id {
                        self.postData = postData
                        
                        // TableViewの現在表示されているセルを更新する
                        self.tableView.reloadData()
                    }
                }
            })
        )
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    /// テーブルビューセクションの数
    ///
    /// - Parameter tableView: テーブルビュー
    /// - Returns: セクション数
    func numberOfSections(in tableView: UITableView) -> Int {
        return PostDetailCellType.count
    }
    
    /// テーブルビューセル数
    ///
    /// - Parameters:
    ///   - tableView: テーブルビュー
    ///   - section: セクション
    /// - Returns: セル数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCnt = 0
        guard let type = PostDetailCellType(rawValue: section) else { return rowCnt }
        
        switch type {
        case .detail:
            // 詳細一つのみ
            rowCnt = 1
        case .comment:
            // コメント数
            if let data = self.postData {
                rowCnt = data.comments.count
            }
        }
        return rowCnt
    }
    
    /// テーブルビューヘッダータイトル
    ///
    /// - Parameters:
    ///   - tableView: テーブルビュー
    ///   - section: セクション
    /// - Returns: タイトル
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        guard let type = PostDetailCellType(rawValue: section) else { return title }
        
        switch type {
        case .detail:
            // 詳細一つのみ
            title = "投稿詳細"
        case .comment:
            // コメント数
            title = "コメント一覧"
        }
        return title
    }
    
    /// セルの設定
    ///
    /// - Parameters:
    ///   - tableView: テーブルビュー
    ///   - indexPath: インデックスパス
    /// - Returns: セル
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let type = PostDetailCellType(rawValue: indexPath.section) else { return UITableViewCell() }
        guard let data = postData else { return UITableViewCell() }
        
        switch type {
        case .detail:
            // 詳細一つのみ
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath as IndexPath) as? PostTableViewCell else { return UITableViewCell() }
            
            // 投稿セット
            cell.setPostData(data)

            // コメント概要は不要なので隠す
            cell.commentOverview.isHidden = true
            // コメントするボタンも不要
            cell.commentWriteButton.isHidden = true
            
            // デリゲート設定
            cell.delegate = self
            
            return cell
            
        case .comment:
            // コメント
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath as IndexPath) as? CommentTableViewCell else { return UITableViewCell() }
            
            // コメントセット
            cell.setComment(data.comments[indexPath.row])
            
            return cell
        }
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
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - PostTableViewCellDelegate
extension PostDetailViewController: PostTableViewCellDelegate {
    
    /// イイネボタン押下時の拡張処理
    ///
    /// - Parameters:
    ///   - sender: ボタン
    ///   - row: ROWナンバー
    func onLikeExtension(_ sender: UIButton, _ row: Int) {
        
        guard let data = self.postData else { return }
        
        // Firebaseに保存するデータの準備
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            if data.isLiked {
                // すでにいいねをしていた場合はいいねを解除するためIDを取り除く
                if let index = data.likes.index(of: uid) {
                    data.likes.remove(at: index)
                }
            } else {
                data.likes.append(uid)
            }
            
            // 増えたlikesをFirebaseに保存する
            let postRef = FIRDatabase.database().reference().child(Const.PostPath).child(data.id!)
            let likes = ["likes": data.likes]
            postRef.updateChildValues(likes)
        }
    }
}
