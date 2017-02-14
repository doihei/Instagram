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
    
    var observingState: [Bool] = [Bool](repeating: false, count: FirebaseObservingEventType.count)
    
    static let shared = FirebaseObservingManager()
}

/// Observing登録確認Util
class FirebaseObservingUtil {
    
    /// Observe登録されているか確認
    ///
    /// - Parameter type: [FirebaseObservingEventType]
    /// - Returns: Bool
    static func isObservingEvent(types: [FirebaseObservingEventType]) -> Bool {
        for type in types {
            guard FirebaseObservingManager.shared.observingState[type.rawValue] else { return false }
        }
        return true
    }
    
    /// Observe登録完了設定
    ///
    /// - Parameter type: FirebaseObservingEventType
    static func setCompleteObserveEvent(types: [FirebaseObservingEventType]) {
        for type in types {
            FirebaseObservingManager.shared.observingState[type.rawValue] = true
        }
    }
    
    /// いずれかが登録完了されているか確認
    ///
    /// - Returns: Bool
    static func isEitherObserving() -> Bool {
        return FirebaseObservingManager.shared.observingState.index(of: true) != nil
    }
    
    /// 全て完了しているかどうか
    ///
    /// - Returns: Bool
    static func isAllObserving() -> Bool {
        return FirebaseObservingManager.shared.observingState.index(of: false) == nil
    }
}
