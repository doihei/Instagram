//
//  Comment.swift
//  Instagram
//
//  Created by 土井大平 on 2017/02/14.
//  Copyright © 2017年 土井大平. All rights reserved.
//

import Foundation

/// コメントモデル
class Comment: NSObject {
    
    var id: String?
    var name: String?
    var comment: String?
    var date: Date?
    
    init(id: String, name: String, comment: String, date: Date) {
        
        self.id = id
        self.name = name
        self.comment = comment
        self.date = date
    }
}
