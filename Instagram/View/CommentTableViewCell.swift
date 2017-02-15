//
//  CommentTableViewCell.swift
//  Instagram
//
//  Created by 土井大平 on 2017/02/14.
//  Copyright © 2017年 土井大平. All rights reserved.
//

import UIKit

import FirebaseAuth

class CommentTableViewCell: UITableViewCell {

    /// コメントしたユーザー名
    @IBOutlet weak var commentNameLabel: UILabel!
    
    /// コメント
    @IBOutlet weak var commentLabel: UILabel!
    
    /// コメント日時
    @IBOutlet weak var commentDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    /// コメントを設定する
    ///
    /// - Parameter comment: コメント
    func setComment(_ comment: Comment) {
        
        if comment.id == FIRAuth.auth()?.currentUser?.uid {
            self.backgroundColor = UIColor.cyan
        }
        
        self.commentNameLabel.text = comment.name
        
        self.commentLabel.text = comment.comment
        
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale!
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.string(from: comment.date!)
        self.commentDateLabel.text = dateString
    }
}
