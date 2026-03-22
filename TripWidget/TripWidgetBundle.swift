//
//  TripWidgetBundle.swift
//  TripWidget
//
//  Created by Sam on 2025/12/15.
//

import WidgetKit
import SwiftUI

@main
struct TripWidgetBundle: WidgetBundle {
    var body: some Widget {
        // 如果你有一般的桌面小工具 (Static Widget)，把這行留著，沒有就刪掉
        // TripWidget()
        
        // 這裡就是把動態島加入 App 的關鍵！
        TripWidgetLiveActivity()
    }
}
