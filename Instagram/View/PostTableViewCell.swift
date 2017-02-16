//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 土井大平 on 2017/02/09.
//  Copyright © 2017年 土井大平. All rights reserved.
//

import UIKit

/// Firebase系
import Firebase
import FirebaseAuth
import FirebaseDatabase

/// 投稿テーブルビューセルデリゲート
@objc protocol PostTableViewCellDelegate {
    @objc optional func onLikeExtension(_ sender: UIButton, _
        row: Int)
    @objc optional func onCommentWriteExtension(_ sender: UIButton, _ row: Int)
    @objc optional func onPostDetailExtension(_ sender: UIButton, _ row: Int)
}

/// 投稿タイムラインCell
class PostTableViewCell: UITableViewCell {

    var delegate: PostTableViewCellDelegate?
    
    /// 保持Row
    private var row = 0
    
    /// 投稿画像
    @IBOutlet weak var postImageView: UIImageView!
    
    /// いいねボタン
    @IBOutlet weak var likeButton: UIButton!
    
    /// いいね個数ラベル
    @IBOutlet weak var likeLabel: UILabel!
    
    /// 日付ラベル
    @IBOutlet weak var dateLabel: UILabel!
    
    /// 説明ラベル
    @IBOutlet weak var captionLabel: UILabel!
    
    /// コメントファーストラベル
    @IBOutlet weak var commentFirstLabel: UILabel!
    
    /// コメントその他
    @IBOutlet weak var otherCommentButton: UIButton!
    
    /// コメントボタン
    @IBOutlet weak var commentWriteButton: UIButton!
    
    /// コメント概要View
    @IBOutlet weak var commentOverview: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /// 投稿データをCellにセット
    ///
    /// - Parameter postData: 投稿データ
    func setPostData(_ postData: PostData, _ row: Int = 0) {
        
        self.row = row
        
        self.postImageView.image = postData.image
        
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale!
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.string(from: postData.date!)
        self.dateLabel.text = dateString
        
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
        
        otherCommentButton.setTitle("\(postData.comments.count)件", for: .normal)
        if let comment = postData.comments.last {
            commentFirstLabel.text = "\(comment.name!)\n\(comment.comment!)"
            commentFirstLabel.textColor = UIColor.black
        } else {
            commentFirstLabel.text = "コメントなし"
            commentFirstLabel.textColor = UIColor.lightGray
        }
    }
    
    /// イイネボタン押下時処理
    ///
    /// - Parameter sender: ボタン
    @IBAction func onLike(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.onLikeExtension?(sender, self.row)
        }
    }
    
    /// コメントするボタン押下時処理
    ///
    /// - Parameter sender: ボタン
    @IBAction func onCommentWrite(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.onCommentWriteExtension?(sender, self.row)
        }
    }
    
    /// otherボタン押下時処理
    ///
    /// - Parameter sender: ボタン
    @IBAction func onPostDetail(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.onPostDetailExtension?(sender, self.row)
        }
    }
}
