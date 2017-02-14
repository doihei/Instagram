//
//  AppDelegate.swift
//  Instagram
//
//  Created by 土井大平 on 2017/02/06.
//  Copyright © 2017年 土井大平. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

/// adobeSDK起動エラー
///
/// - noPlist: プレイリストがない
/// - noDictionaryKey: 該当キーがない
enum AdobeError : Error {
    case noPlist
    case noDictionaryKey(String)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    /// アドビの設定
    ///
    /// - Throws: AdobeError
    private func setAdobeSDK() throws {
        // adobeSDKを用いるための情報
        if let adobeSDKDictPath = Bundle.main.path(forResource: "Adobe-sdk-Info", ofType: "plist") {
            let adobeSDKDict = NSDictionary(contentsOfFile: adobeSDKDictPath)
            
            // Adobe先生の起動
            guard let apiKey = adobeSDKDict?["API_KEY"] as? String else { throw AdobeError.noDictionaryKey("API_KEY") }
            guard let clientSecret = adobeSDKDict?["CLIENT_SECRET"] as? String else { throw AdobeError.noDictionaryKey("CLIENT_SECRET") }
            AdobeUXAuthManager.shared().setAuthenticationParametersWithClientID(apiKey, withClientSecret: clientSecret)
        } else {
            // plistがない場合
            throw AdobeError.noPlist
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        
        do {
            // アドビの設定
            try setAdobeSDK()
        } catch let error {
            guard let adobeError = error as? AdobeError else { return true }
            switch adobeError {
            case .noPlist:
                SVProgressHUD.showError(withStatus: "Adobe-sdk-info.plistが存在しません。\nプロジェクトを確認してください。")
            case .noDictionaryKey(let key):
                SVProgressHUD.showError(withStatus: "\(key)が存在しません。\nAdobe-sdk-info.plistを確認してください。")
            }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

