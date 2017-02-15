//
//  FirebaseObservingEventType.swift
//  Instagram
//
//  Created by 土井大平 on 2017/02/14.
//  Copyright © 2017年 土井大平. All rights reserved.
//

import Foundation

/// FirebaseObservingイベントタイプ
enum FirebaseObservingEventType: Int {
    
    /// ホーム画面のAddイベント
    case timelineAdded = 0
    
    /// ホーム画面のchangeイベント
    case timelineChanged
    
    /// 投稿詳細画面のchangeイベント
    case postDetailChanged
    
    static var count: Int {
        var i = 0
        while let _ = FirebaseObservingEventType(rawValue: i) { i += 1 }
        return i
    }
}

/// Observing登録確認保持クラス(シングルトン)
class FirebaseObservingManager {
    
    /// 設定した後のUInt保持配列
    var observingIdentifier: [UInt?] = [UInt?](repeating: nil, count: FirebaseObservingEventType.count)
    
    static let shared = FirebaseObservingManager()
    
    private init() {}
}

/// Observing登録確認Util
class FirebaseObservingUtil {
    
    /// Observe登録されているか確認(複数版)
    ///
    /// - Parameter type: [FirebaseObservingEventType]
    /// - Returns: Bool
    static func isObservingEvent(types: [FirebaseObservingEventType]) -> Bool {
        NSLog("observingIdentifier: \(FirebaseObservingManager.shared.observingIdentifier)")
        for type in types {
            guard let _ = FirebaseObservingManager.shared.observingIdentifier[type.rawValue] else { return false }
        }
        return true
    }
    
    /// Observe登録されているか確認
    ///
    /// - Parameter type: FirebaseObservingEventType
    /// - Returns: Bool
    static func isObservingEvent(type: FirebaseObservingEventType) -> Bool {
        NSLog("observingIdentifier: \(FirebaseObservingManager.shared.observingIdentifier)")
        guard let _ = FirebaseObservingManager.shared.observingIdentifier[type.rawValue] else { return false }
        return true
    }
    
    /// 該当Identifierを取得
    ///
    /// - Parameter type: FirebaseObservingEventType
    /// - Returns: 識別子
    static func getObservingIdentifier(type: FirebaseObservingEventType) -> UInt? {
        NSLog("observingIdentifier: \(FirebaseObservingManager.shared.observingIdentifier)")
        return FirebaseObservingManager.shared.observingIdentifier[type.rawValue]
    }
    
    /// Observe登録完了設定
    ///
    /// - Parameter type: FirebaseObservingEventType
    static func setCompleteObserveEvent(type: FirebaseObservingEventType, identifier: UInt) {
        NSLog("observingIdentifier: \(FirebaseObservingManager.shared.observingIdentifier)")
        FirebaseObservingManager.shared.observingIdentifier[type.rawValue] = identifier
    }
    
    /// 削除
    ///
    /// - Parameter type: FirebaseObservingEventType
    static func removeObserving(type: FirebaseObservingEventType) {
        NSLog("observingIdentifier: \(FirebaseObservingManager.shared.observingIdentifier)")
        FirebaseObservingManager.shared.observingIdentifier[type.rawValue] = nil
    }
    
    /// 全て削除
    ///
    /// - Parameter type: FirebaseObservingEventType
    static func removeAllObserving() {
        NSLog("observingIdentifier: \(FirebaseObservingManager.shared.observingIdentifier)")
        FirebaseObservingManager.shared.observingIdentifier = [UInt?](repeating: nil, count: FirebaseObservingEventType.count)
    }
    
    /// いずれかが登録完了されているか確認
    ///
    /// - Returns: Bool
    static func isEitherObserving() -> Bool {
        NSLog("observingIdentifier: \(FirebaseObservingManager.shared.observingIdentifier)")
        return FirebaseObservingManager.shared.observingIdentifier.filter({ $0 != nil }).count > 0
    }
    
    /// 全て完了しているかどうか
    ///
    /// - Returns: Bool
    static func isAllObserving() -> Bool {
        NSLog("observingIdentifier: \(FirebaseObservingManager.shared.observingIdentifier)")
        return FirebaseObservingManager.shared.observingIdentifier.filter({ $0 != nil }).count == FirebaseObservingEventType.count
    }
}
