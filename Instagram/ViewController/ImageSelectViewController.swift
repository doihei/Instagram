//
//  ImageSelectViewController.swift
//  Instagram
//
//  Created by 土井大平 on 2017/02/06.
//  Copyright © 2017年 土井大平. All rights reserved.
//

import UIKit
import MobileCoreServices

/// 画像選択画面
class ImageSelectViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /// ライブラリボタン押下時処理
    ///
    /// - Parameter sender: ボタン
    @IBAction func onLibrary(_ sender: UIButton) {
        
        // ライブラリ（カメラロール）を指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            pickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String]
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    /// 画像撮影ボタン押下時処理
    ///
    /// - Parameter sender: ボタン
    @IBAction func onCamera(_ sender: UIButton) {
        // カメラを指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .camera
            pickerController.mediaTypes = [kUTTypeImage as String]
            pickerController.cameraCaptureMode = .photo
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    /// 動画撮影ボタン押下時処理
    ///
    /// - Parameter sender: ボタン
    @IBAction func onVideoCamera(_ sender: UIButton) {
        // カメラを指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .camera
            pickerController.mediaTypes = [kUTTypeMovie as String]
            pickerController.cameraCaptureMode = .video
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    /// キャンセル押下時処理
    ///
    /// - Parameter sender: ボタン
    @IBAction func onCancel(_ sender: UIButton) {
        // 画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
}


// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ImageSelectViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// 写真を撮影/選択したときに呼ばれるメソッド
    ///
    /// - Parameters:
    ///   - picker: ピッカー
    ///   - info: 情報体
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            // 撮影/選択された画像を取得する
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            // AdobeUXImageEditorで、受け取ったimageを加工できる
            // ここでpresentViewControllerを呼び出しても表示されないためメソッドが終了してから呼ばれるようにする
            DispatchQueue.main.async {
                // AdobeImageEditorを起動する
                let adobeViewController = AdobeUXImageEditorViewController(image: image)
                adobeViewController.delegate = self
                self.present(adobeViewController, animated: true, completion:  nil)
            }
            
        }
        
        // 閉じる
        picker.dismiss(animated: true, completion: nil)
    }
    
    /// ピッカー閉じる
    ///
    /// - Parameter picker: ピッカー
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // 閉じる
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - AdobeUXImageEditorViewControllerDelegate
extension ImageSelectViewController: AdobeUXImageEditorViewControllerDelegate {
    
    /// 加工が終わった時に呼ばれるメソッド
    ///
    /// - Parameters:
    ///   - editor: エディター
    ///   - image: 加工後画像
    func photoEditor(_ editor: AdobeUXImageEditorViewController, finishedWith image: UIImage?) {
        // 画像加工画面を閉じる
        editor.dismiss(animated: true, completion: nil)
        
        // 投稿の画面を開く
        let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! PostViewController
        postViewController.image = image
        present(postViewController, animated: true, completion: nil)
    }
    
    /// 加工キャンセル押された時に呼ばれるメソッド
    ///
    /// - Parameter editor: エディター
    func photoEditorCanceled(_ editor: AdobeUXImageEditorViewController) {
        // 画像加工画面を閉じる
        editor.dismiss(animated: true, completion: nil)
        
    }
}
