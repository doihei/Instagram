//
//  PostPreviewView.swift
//  Instagram
//
//  Created by 土井大平 on 2017/03/28.
//  Copyright © 2017年 土井大平. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

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
                imageView.frame = self.bounds
                self.addSubview(imageView)
            case .movie:
                // 動画の貼り付け
                let url = URL(string: data.removingPercentEncoding!)!
                let avPlayer = AVPlayer(url: url)
                
                // Layerを生成.設定
                let avPlayerLayer = AVPlayerLayer(player: avPlayer)
                avPlayerLayer.frame = self.bounds
                self.layer.addSublayer(avPlayerLayer)
                
                // 再生
                avPlayer.play()
            }
        }
    }
}
