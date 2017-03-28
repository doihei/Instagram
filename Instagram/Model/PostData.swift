//
//  PostData.swift
//  Instagram
//
//  Created by 土井大平 on 2017/02/09.
//  Copyright © 2017年 土井大平. All rights reserved.
//

import Foundation

/// Firebase系
import Firebase
import FirebaseDatabase


/// 投稿データタイプ
///
/// - image: 画像
/// - movie: 動画
enum PostType: Int {
    case image, movie
}

/// 投稿データモデル
class PostData: NSObject {
    var id: String?
    var dataString: String?
    var postType: PostType?
    var name: String?
    var caption: String?
    var date: Date?
    var likes: [String] = []
    var comments: [Comment] = []
    var isLiked: Bool = false
    
    init(snapshot: FIRDataSnapshot, myId: String) {
        self.id = snapshot.key
        
        let valueDictionary = snapshot.value as! [String: AnyObject]
        
        self.postType = PostType(rawValue: Int(valueDictionary["post_type"] as! String)!)
        
        self.dataString = valueDictionary["data"] as? String
        
        self.name = valueDictionary["name"] as? String
        
        self.caption = valueDictionary["caption"] as? String
        
        let time = valueDictionary["time"] as? String
        self.date = Date(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
        
        if let likes = valueDictionary["likes"] as? [String] {
            self.likes = likes
        }
        
        // コメントオブジェクト
        if let comments = valueDictionary["comments"] as? [[String: AnyObject]] {
            for comment in comments {
                guard let commentId = comment["id"] as? String else { continue }
                guard let commentName = comment["name"] as? String else { continue }
                guard let commentText = comment["comment"] as? String else { continue }
                guard let commentDate = comment["date"] as? String else { continue }
                
                self.comments.append(Comment(id: commentId, name: commentName, comment: commentText, date: Date(timeIntervalSinceReferenceDate: TimeInterval(commentDate)!)))
            }
            
            // 日付順ソート
            self.comments.sort{ $0.date!.compare($1.date!) == .orderedAscending }
        }
        
        if let _ = self.likes.index(of: myId) {
            self.isLiked = true
        }
    }
}
