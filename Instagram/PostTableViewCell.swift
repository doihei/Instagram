//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 土井大平 on 2017/02/09.
//  Copyright © 2017年 土井大平. All rights reserved.
//

import UIKit

/// 投稿タイムラインCell
class PostTableViewCell: UITableViewCell {

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
    func setPostData(_ postData: PostData) {
        self.postImageView.image = postData.image
        
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale!
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.string(from: postData.date! as Date)
        self.dateLabel.text = dateString
        
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
    }
}
