import ActivityKit
import WidgetKit
import SwiftUI

// MARK: - 🎨 外觀與排版設定區
private let useWhiteTheme = true
private let activityOpacity: Double = 0.6
private let horizontalPadding: CGFloat = 20.0

private let lockScreenTextColor: Color = useWhiteTheme ? .black : .white
private let expandedTextColor: Color = .white

// MARK: - 資料結構
struct TripAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var currentStatus: String
        var showCountdown: Bool
        var useDarkMode: Bool
    }
    var iconName: String
    var isSystemImage: Bool
    var statusLabel: String
    var transportName: String
    var departureTime: String
    var arrivalTime: String
    var seatInfo: String
    var terminalInfo: String
    var route: String
    var estimatedTime: Date
    var tintColor: String
}

struct TripWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TripAttributes.self) { context in
            // MARK: - 📱 鎖定畫面 (Lock Screen)
            let isDarkMode = context.state.useDarkMode
            let backgroundColor = isDarkMode ? Color.black.opacity(0.6) : Color.white.opacity(activityOpacity)
            let textColor = isDarkMode ? Color.white : Color.black
            
            VStack(alignment: .leading) {
                HStack {
                    if context.attributes.isSystemImage {
                        Image(systemName: context.attributes.iconName)
                            .foregroundStyle(Color(hex: context.attributes.tintColor))
                    } else {
                        Image(context.attributes.iconName)
                            .resizable().scaledToFit().padding(2)
                            .background(Color.white).clipShape(RoundedRectangle(cornerRadius: 4)).frame(width: 24, height: 24)
                    }
                    Text(context.attributes.transportName).font(.headline).foregroundStyle(textColor)
                }
                Spacer().frame(height: 8)
                HStack {
                    VStack(alignment: .leading) {
                        Text(context.attributes.statusLabel).font(.caption).foregroundStyle(.gray)
                        // 🔧 修正：改回 .headline (跟座位一樣大)，不要超大字體
                        Text(context.attributes.departureTime)
                            .font(.headline)
                            .bold()
                            .foregroundStyle(textColor)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("座位").font(.caption).foregroundStyle(.gray)
                        // 🔧 修正：維持 .headline
                        Text(context.attributes.seatInfo)
                            .font(.headline)
                            .bold()
                            .foregroundStyle(textColor)
                    }
                }
                Text(context.attributes.route).font(.footnote).padding(.top, 4).foregroundStyle(.gray)
            }
            .padding().activityBackgroundTint(backgroundColor)
            
        } dynamicIsland: { context in
            DynamicIsland {
                // MARK: - 🏝️ 展開模式 (完全維持原本調好的樣子，不亂動)
                DynamicIslandExpandedRegion(.leading) {
                    VStack {
                        Text(context.attributes.statusLabel).font(.caption).foregroundStyle(.gray)
                        Text(context.attributes.departureTime).font(.title).bold().foregroundStyle(expandedTextColor)
                    }
                    .padding(.leading, horizontalPadding)
                }
                DynamicIslandExpandedRegion(.center) {
                    VStack {
                        Text(" ").font(.caption)
                        // ✅ 維持你最滿意的 -12
                        Image(systemName: "arrow.right").font(.title3).bold().foregroundStyle(.white).offset(y: -12)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack {
                        Text("抵達").font(.caption).foregroundStyle(.gray)
                        Text(context.attributes.arrivalTime.isEmpty ? "-" : context.attributes.arrivalTime).font(.title).bold().foregroundStyle(expandedTextColor)
                    }
                    .padding(.trailing, horizontalPadding)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(spacing: 0) {
                        HStack(alignment: .center) {
                            HStack(spacing: 6) {
                                if context.attributes.isSystemImage {
                                    Image(systemName: context.attributes.iconName).foregroundStyle(Color(hex: context.attributes.tintColor))
                                } else {
                                    Image(context.attributes.iconName).resizable().scaledToFit().padding(1).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 4)).frame(width: 20, height: 20)
                                }
                                Text(context.attributes.transportName).font(.headline).foregroundStyle(expandedTextColor).lineLimit(1)
                            }
                            Spacer()
                            HStack(alignment: .firstTextBaseline, spacing: 4) {
                                Text("座位").font(.caption).foregroundStyle(.gray)
                                Text(context.attributes.seatInfo).font(.headline).bold().foregroundStyle(expandedTextColor)
                            }
                        }
                        .padding(.bottom, 6)
                        HStack(alignment: .center) {
                            Text(context.attributes.route).font(.subheadline).foregroundStyle(.gray).lineLimit(1).minimumScaleFactor(0.8)
                            Spacer()
                            if context.attributes.terminalInfo != "-" {
                                HStack(alignment: .firstTextBaseline, spacing: 4) {
                                    Text("航廈").font(.caption).foregroundStyle(.gray)
                                    Text(context.attributes.terminalInfo).font(.subheadline).bold().foregroundStyle(expandedTextColor)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16).padding(.top, 2).padding(.bottom, 4)
                }
            } compactLeading: {
                if context.attributes.isSystemImage {
                    Image(systemName: context.attributes.iconName).foregroundStyle(Color(hex: context.attributes.tintColor))
                } else {
                    Image(context.attributes.iconName).resizable().scaledToFit().padding(1).background(Color.white).clipShape(Circle())
                }
            } compactTrailing: {
                // ✅ 修正：這裡預設改為顯示「發車時間」
                // (我把倒數計時的邏輯拿掉了，這樣最穩定)
                Text(context.attributes.departureTime)
                    .font(.body)
                    .multilineTextAlignment(.trailing)
                    .monospacedDigit()
                    .foregroundStyle(.white)
            } minimal: {
                // ✅ 修正：這裡也改為顯示「發車時間」
                Text(context.attributes.departureTime)
                    .foregroundStyle(.white)
            }
        }
    }
}

// 顏色轉換工具 (保持不變)
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

#Preview("Notification", as: .content, using: TripAttributes(
    iconName: "ana_logo", isSystemImage: false, statusLabel: "起飛", transportName: "NH854 (ANA)", departureTime: "16:50", arrivalTime: "20:40", seatInfo: "14B", terminalInfo: "T1 → T2", route: "台北(松山) → 東京(羽田)", estimatedTime: Date(), tintColor: "FFA500"
)) {
   TripWidgetLiveActivity()
} contentStates: {
    TripAttributes.ContentState(currentStatus: "準點", showCountdown: true, useDarkMode: true)
}
