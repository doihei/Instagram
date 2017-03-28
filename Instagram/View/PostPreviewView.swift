//
//  PostPreviewView.swift
//  Instagram
//
//  Created by 土井大平 on 2017/03/28.
//  Copyright © 2017年 土井大平. All rights reserved.
//

import UIKit

class PostPreviewView: UIView {

    /// 投稿タイプ
    var postType: PostType = .image

    /// データ
    var dataString: String?
    
    /// プレビュー開始
    ///
    /// - Parameters:
    ///   - dataString: データ文字列
    ///   - type: 投稿タイプ
    public func preview(dataString: String, _ type: PostType = .image) {
        
        self.dataString = dataString
        self.postType = type
        
        if let data = self.dataString {
            // 投稿タイプによって処理分け
            switch postType {
            case .image:
                // 画像の貼り付け
                let imageView = UIImageView(image: UIImage(data: Data(base64Encoded: data, options: .ignoreUnknownCharacters)!))
                imageView.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: self.frame.width, height: self.frame.height)
                self.addSubview(imageView)
            case .movie:
                // 動画の貼り付け
                break
            default:
                break
            }
        }
    }
}
