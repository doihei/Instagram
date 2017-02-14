//
//  PostDetailViewController.swift
//  Instagram
//
//  Created by 土井大平 on 2017/02/13.
//  Copyright © 2017年 土井大平. All rights reserved.
//

import UIKit
import ESTabBarController

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
        
        // タブ隠しておく
        let tabBarController = parent?.parent as! ESTabBarController
        tabBarController.setBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
