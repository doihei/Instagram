//
//  PostDetailViewController.swift
//  Instagram
//
//  Created by 土井大平 on 2017/02/13.
//  Copyright © 2017年 土井大平. All rights reserved.
//

import UIKit

/// 投稿詳細画面
class PostDetailViewController: CommentBaseViewController {

    /// 該当投稿データ
    var postData: PostData?
    
    /// テーブルビュー
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // テーブルセルタップの無効
        tableView.allowsSelection = false
        
        // キーボード制御
        tableView.keyboardDismissMode = .onDrag
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    /// テーブルビューセル数
    ///
    /// - Parameters:
    ///   - tableView: テーブルビュー
    ///   - section: セクション
    /// - Returns: セル数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _ = self.postData else { return 0 }
        return 1
    }
    
    /// セルの設定
    ///
    /// - Parameters:
    ///   - tableView: テーブルビュー
    ///   - indexPath: インデックスパス
    /// - Returns: セル
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
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
    }
}
