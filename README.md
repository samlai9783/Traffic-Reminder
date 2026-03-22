# 交通提醒小助手 Travel Reminder

**交通提醒小助手**是一款專為旅行者設計的 iOS 行程管理 App。它可以將火車、飛機、巴士班次資訊「釘選」在動態島與鎖定畫面上。

無論是跨國飛行還是轉乘新幹線，只需瞥一眼手機，發車時間、座位號碼與目的地一目瞭然，讓你不再手忙腳亂找車票！

---

## 功能亮點 Features

* **動態島與即時動態**
    * 支援將單一行程釘選至動態島。
    * 透過動態島的展開模式可以快速了解完整行程資訊。
* **國際化跨時區支援**
    * 針對跨國旅行（如台灣飛往日本）設計，支援分別設定「出發地時區」與「抵達地時區」。
    * 動態島上永遠顯示精準的當地時間，徹底解決時差換算煩惱。
* **直覺的行程管理**
    * 支援新增火車、飛機、巴士等不同交通工具，並自動套用對應的系統圖示與主題色。
    * **手勢操作**：左滑刪除行程、右滑編輯行程。
    * **自動排序**：行程會自動依照「出發時間」排序，確保接下來的行程永遠在最上方。

---

## 畫面展示 Screenshots

<table align="center">
  <tr align="center">
    <th>主畫面清單 Main App</th>
    <th>鎖定畫面即時動態 Lock Screen</th>
  </tr>
  <tr align="center">
    <td valign="top">
      <img width="250" src="https://github.com/user-attachments/assets/cb46d3fb-1c79-4d7e-bef8-e90d415f5632" />
    </td>
    <td valign="top">
      <img width="250" src="https://github.com/user-attachments/assets/02096cbd-6ac4-46b0-a28a-5677ca5dc66b" />
    </td>
  </tr>
  <tr align="center">
    <th>動態島：展開模式(Expanded)</th>
    <th>動態島：緊湊模式(Compact)</th>
  </tr>
  <tr align="center">
    <td valign="top">
      <img width="250" src="https://github.com/user-attachments/assets/d458e0ab-4de8-45ce-98a2-ea0c1c7fca18" />
    </td>
    <td valign="top">
      <img width="250" src="https://github.com/user-attachments/assets/070de25b-723a-4be4-b867-ee3def43c8f8" />
    </td>
  </tr>
</table>

---
## 待新增功能 Upcoming Features
* 讓使用者可以自訂緊湊模式所顯示的資訊為發車時間、到達時間或是座位
* 增加更多交通工具icon供使用者選擇

---
## 使用技術 Tech Stack

* **平台:** iOS 18.5+
* **語言:** Swift 5
* **UI 框架:** SwiftUI
* **核心框架:** * `ActivityKit` (實作動態島與 Live Activities)
    * `Foundation` (DateFormatter, JSONEncoder/Decoder 處理跨時區與資料存儲)

---

### 系統需求
* Xcode 15.0 或以上版本
* iOS 17.0 或以上版本的實機或模擬器 (推薦使用具備動態島的機型，如 iPhone 14 Pro 或 iPhone 15/16/17 系列)
