import SwiftUI
import ActivityKit

// MARK: - 1. 共用時區清單 (全球完整版)
let commonTimeZones = [
    ("Pacific/Niue", "紐埃 (GMT-11)"),
    ("Pacific/Honolulu", "檀香山 (GMT-10)"),
    ("Pacific/Marquesas", "馬克薩斯群島 (GMT-9:30)"),
    ("America/Anchorage", "安克拉治 (GMT-9)"),
    ("America/Los_Angeles", "洛杉磯 (GMT-8)"),
    ("America/Denver", "丹佛 (GMT-7)"),
    ("America/Chicago", "芝加哥 (GMT-6)"),
    ("America/New_York", "紐約 (GMT-5)"),
    ("America/Halifax", "哈利法克斯 (GMT-4)"),
    ("America/St_Johns", "聖約翰斯 (GMT-3:30)"),
    ("America/Sao_Paulo", "聖保羅 (GMT-3)"),
    ("Atlantic/South_Georgia", "南喬治亞 (GMT-2)"),
    ("Atlantic/Azores", "亞速群島 (GMT-1)"),
    ("Europe/London", "倫敦 (GMT+0)"),
    ("Europe/Paris", "巴黎 (GMT+1)"),
    ("Africa/Cairo", "開羅 (GMT+2)"),
    ("Europe/Moscow", "莫斯科 (GMT+3)"),
    ("Asia/Tehran", "德黑蘭 (GMT+3:30)"),
    ("Asia/Dubai", "杜拜 (GMT+4)"),
    ("Asia/Kabul", "喀布爾 (GMT+4:30)"),
    ("Asia/Karachi", "喀拉蚩 (GMT+5)"),
    ("Asia/Kolkata", "新德里 (GMT+5:30)"),
    ("Asia/Kathmandu", "加德滿都 (GMT+5:45)"),
    ("Asia/Dhaka", "達卡 (GMT+6)"),
    ("Asia/Yangon", "仰光 (GMT+6:30)"),
    ("Asia/Bangkok", "曼谷 (GMT+7)"),
    ("Asia/Taipei", "台北 (GMT+8)"),
    ("Asia/Singapore", "新加坡 (GMT+8)"),
    ("Australia/Eucla", "尤克拉 (GMT+8:45)"),
    ("Asia/Tokyo", "東京 (GMT+9)"),
    ("Asia/Seoul", "首爾 (GMT+9)"),
    ("Australia/Adelaide", "阿得雷德 (GMT+9:30)"),
    ("Australia/Sydney", "雪梨 (GMT+10)"),
    ("Australia/Lord_Howe", "豪勳爵島 (GMT+10:30)"),
    ("Pacific/Noumea", "努美阿 (GMT+11)"),
    ("Pacific/Auckland", "奧克蘭 (GMT+12)"),
    ("Pacific/Chatham", "查塔姆群島 (GMT+12:45)"),
    ("Pacific/Tongatapu", "東加塔布 (GMT+13)"),
    ("Pacific/Kiritimati", "聖誕島 (GMT+14)")
]
// MARK: - 2. 資料模型
struct Trip: Identifiable, Codable, Equatable {
    var id = UUID()
    let year: String
    let date: String
    let iconName: String
    let isSystemImage: Bool
    let statusLabel: String
    let transportName: String
    let departureTime: String
    let arrivalTime: String
    let seatInfo: String
    let terminalInfo: String
    let route: String
    let tintColor: String
    
    // 🆕 新增：儲存出發與抵達的時區
    var departureTimeZone: String = "Asia/Taipei"
    var arrivalTimeZone: String = "Asia/Taipei"

    var color: Color {
        switch tintColor {
        case "FFA500": return .orange
        case "c7f9ff": return .blue
        case "c7ffd3": return .green
        case "D3D3D3": return .gray
        default: return .primary
        }
    }
    
    // 🆕 排序與動態島倒數用的絕對時間（使用出發地的時區來計算）
    var actualDepartureDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/M/d HH:mm"
        formatter.timeZone = TimeZone(identifier: departureTimeZone) ?? .current
        return formatter.date(from: "\(year)/\(date) \(departureTime)") ?? Date.distantPast
    }
}

// MARK: - 3. 預設顯示資料
let defaultTrips: [Trip] = [
    Trip(year: "2026", date: "1/1", iconName: "hand.draw.fill", isSystemImage: true, statusLabel: "教學", transportName: "左滑刪除，右滑編輯", departureTime: "00:00", arrivalTime: "23:59", seatInfo: "-", terminalInfo: "-", route: "試著向左或向右滑動這張卡片", tintColor: "D3D3D3", departureTimeZone: "Asia/Taipei", arrivalTimeZone: "Asia/Taipei"),
    Trip(year: "2026", date: "4/1", iconName: "train.side.front.car", isSystemImage: true, statusLabel: "發車", transportName: "新幹線 (示範)", departureTime: "08:00", arrivalTime: "10:30", seatInfo: "3車 14A", terminalInfo: "-", route: "東京 → 大阪", tintColor: "c7ffd3", departureTimeZone: "Asia/Tokyo", arrivalTimeZone: "Asia/Tokyo"),
    // 🆕 示範跨時區：台北起飛(台灣時間) -> 東京降落(日本時間)
    Trip(year: "2026", date: "4/2", iconName: "airplane", isSystemImage: true, statusLabel: "起飛", transportName: "星宇航空 JX800 (示範)", departureTime: "08:30", arrivalTime: "12:45", seatInfo: "22A", terminalInfo: "T1 → T2", route: "台北(TPE) → 東京(NRT)", tintColor: "FFA500", departureTimeZone: "Asia/Taipei", arrivalTimeZone: "Asia/Tokyo"),
    Trip(year: "2026", date: "4/3", iconName: "bus.fill", isSystemImage: true, statusLabel: "發車", transportName: "高速巴士 (示範)", departureTime: "09:00", arrivalTime: "11:00", seatInfo: "1A", terminalInfo: "-", route: "新宿 → 河口湖", tintColor: "c7f9ff", departureTimeZone: "Asia/Tokyo", arrivalTimeZone: "Asia/Tokyo")
]

// MARK: - 3.1 日本行程範例資料庫 (已配置精準時區)
let japanTrips: [Trip] = [
    Trip(year: "2025", date: "12/16", iconName: "train.side.front.car", isSystemImage: true, statusLabel: "發車", transportName: "富士迴遊號 (JR)", departureTime: "18:10", arrivalTime: "19:00", seatInfo: "7A", terminalInfo: "-", route: "東京 → スカイツリー", tintColor: "c7ffd3", departureTimeZone: "Asia/Tokyo", arrivalTimeZone: "Asia/Tokyo"),
    Trip(year: "2026", date: "1/8", iconName: "ana_logo", isSystemImage: false, statusLabel: "起飛", transportName: "NH854 (ANA)", departureTime: "16:50", arrivalTime: "20:40", seatInfo: "14B", terminalInfo: "T1 → T2", route: "台北(松山) → 東京(羽田)", tintColor: "FFA500", departureTimeZone: "Asia/Taipei", arrivalTimeZone: "Asia/Tokyo"), // 🇹🇼飛🇯🇵
    Trip(year: "2026", date: "1/10", iconName: "train.side.front.car", isSystemImage: true, statusLabel: "發車", transportName: "富士迴遊號 (JR)", departureTime: "07:07", arrivalTime: "09:28", seatInfo: "1號車 8D", terminalInfo: "-", route: "錦糸町 → 河口湖", tintColor: "c7ffd3", departureTimeZone: "Asia/Tokyo", arrivalTimeZone: "Asia/Tokyo"),
    Trip(year: "2026", date: "1/11", iconName: "bus.fill", isSystemImage: true, statusLabel: "發車", transportName: "高速巴士 2030便", departureTime: "10:20", arrivalTime: "12:30", seatInfo: "1號車 6A/6B", terminalInfo: "-", route: "河口湖 → 澀谷", tintColor: "c7f9ff", departureTimeZone: "Asia/Tokyo", arrivalTimeZone: "Asia/Tokyo"),
    Trip(year: "2026", date: "1/13", iconName: "ana_logo", isSystemImage: false, statusLabel: "起飛", transportName: "NH019 (ANA)", departureTime: "10:00", arrivalTime: "11:10", seatInfo: "30B", terminalInfo: "T2 → T1", route: "東京(羽田) → 大阪(伊丹)", tintColor: "FFA500", departureTimeZone: "Asia/Tokyo", arrivalTimeZone: "Asia/Tokyo"),
    Trip(year: "2026", date: "1/13", iconName: "ana_logo", isSystemImage: false, statusLabel: "起飛", transportName: "NH735 (ANA)", departureTime: "12:30", arrivalTime: "13:50", seatInfo: "6D", terminalInfo: "T1 → T1", route: "大阪(伊丹) → 仙台", tintColor: "FFA500", departureTimeZone: "Asia/Tokyo", arrivalTimeZone: "Asia/Tokyo"),
    Trip(year: "2026", date: "1/17", iconName: "ana_logo", isSystemImage: false, statusLabel: "起飛", transportName: "NH1229 (ANA)", departureTime: "17:20", arrivalTime: "18:35", seatInfo: "15K", terminalInfo: "T1 → D", route: "仙台 → 札幌(新千歲)", tintColor: "FFA500", departureTimeZone: "Asia/Tokyo", arrivalTimeZone: "Asia/Tokyo"),
    Trip(year: "2026", date: "1/23", iconName: "ana_logo", isSystemImage: false, statusLabel: "起飛", transportName: "NH054 (ANA)", departureTime: "09:30", arrivalTime: "11:10", seatInfo: "41K", terminalInfo: "D → T2", route: "札幌(新千歲) → 東京(羽田)", tintColor: "FFA500", departureTimeZone: "Asia/Tokyo", arrivalTimeZone: "Asia/Tokyo"),
    Trip(year: "2026", date: "1/23", iconName: "ana_logo", isSystemImage: false, statusLabel: "起飛", transportName: "NH853 (ANA)", departureTime: "12:40", arrivalTime: "15:50", seatInfo: "29F", terminalInfo: "T2 → T1", route: "東京(羽田) → 台北(松山)", tintColor: "FFA500", departureTimeZone: "Asia/Tokyo", arrivalTimeZone: "Asia/Taipei") // 🇯🇵飛🇹🇼
]

// MARK: - 4. 主畫面
struct ContentView: View {
    @State private var currentActiveTripID: UUID? = nil
    @State private var processingTripID: UUID? = nil
    
    @AppStorage("useDarkMode") private var useDarkMode = true
    @AppStorage("savedTripsData") private var savedTripsData: Data = Data()
    
    @State private var trips: [Trip] = []
    
    @State private var isShowingAddView = false
    @State private var tripToEdit: Trip? = nil
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                tripList
                bottomButtons
            }
            .navigationTitle(Text("\(Image(systemName: "map.fill")) 交通提醒小助手"))
            .sheet(isPresented: $isShowingAddView) {
                TripFormView(editingTrip: nil) { newTrip in
                    withAnimation {
                        trips.append(newTrip)
                        trips.sort { $0.actualDepartureDate < $1.actualDepartureDate }
                    }
                }
            }
            .sheet(item: $tripToEdit) { trip in
                TripFormView(editingTrip: trip) { updatedTrip in
                    if let index = trips.firstIndex(where: { $0.id == updatedTrip.id }) {
                        withAnimation {
                            trips[index] = updatedTrip
                            trips.sort { $0.actualDepartureDate < $1.actualDepartureDate }
                        }
                        
                        if currentActiveTripID == updatedTrip.id {
                            startActivity(for: updatedTrip)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Section("資料管理") {
                            Button {
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.impactOccurred()
                                withAnimation {
                                    trips = japanTrips.sorted { $0.actualDepartureDate < $1.actualDepartureDate }
                                }
                            } label: {
                                Label("載入日本行程範例", systemImage: "map.fill")
                            }
                            
                            Button {
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.impactOccurred()
                                withAnimation {
                                    trips = defaultTrips.sorted { $0.actualDepartureDate < $1.actualDepartureDate }
                                }
                            } label: {
                                Label("還原預設畫面", systemImage: "arrow.triangle.2.circlepath")
                            }
                        }
                        Section("外觀") {
                            Toggle(isOn: $useDarkMode) {
                                Label("深色模式 (鎖定畫面)", systemImage: "moon.fill")
                            }
                        }
                    } label: {
                        Image(systemName: "gearshape.fill").font(.title3).foregroundStyle(.blue) // 讓圖標保持藍色
                    }
                }
            }
            .onAppear {
                if let decoded = try? JSONDecoder().decode([Trip].self, from: savedTripsData), !decoded.isEmpty {
                    trips = decoded.sorted { $0.actualDepartureDate < $1.actualDepartureDate }
                } else {
                    trips = defaultTrips.sorted { $0.actualDepartureDate < $1.actualDepartureDate }
                }
            }
            .onChange(of: trips) { oldValue, newValue in
                if let encoded = try? JSONEncoder().encode(newValue) {
                    savedTripsData = encoded
                }
            }
            .onChange(of: useDarkMode) { oldValue, newValue in updateExistingActivity() }
        }
    }
    
    // MARK: - UI 拆分區塊
    
    private var tripList: some View {
        List {
            ForEach(trips) { trip in
                TripRowView(
                    trip: trip,
                    isActive: currentActiveTripID == trip.id,
                    isProcessing: processingTripID == trip.id
                ) {
                    handleTripSelection(trip)
                }
                .listRowBackground(currentActiveTripID == trip.id ? Color.green.opacity(0.05) : Color.clear)
                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                    Button {
                        tripToEdit = trip
                    } label: {
                        Label("編輯", systemImage: "pencil")
                    }
                    .tint(.blue)
                }
            }
            .onDelete(perform: deleteTrip)
        }
        .listStyle(.inset)
    }
    
    private var bottomButtons: some View {
        HStack(spacing: 16) {
            Button {
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
                stopActivity()
                withAnimation { currentActiveTripID = nil }
            } label: {
                HStack {
                    Image(systemName: "trash.fill")
                    Text("清除動態島").fontWeight(.bold)
                }
                .font(.headline).foregroundStyle(.red).padding()
                .frame(maxWidth: .infinity)
                .background(Color.red.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.red, lineWidth: 1))
            }
            .buttonStyle(BouncyButtonStyle())
            
            Button {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                isShowingAddView = true
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("新增活動").fontWeight(.bold)
                }
                .font(.headline).foregroundStyle(.blue).padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.blue, lineWidth: 1))
            }
            .buttonStyle(BouncyButtonStyle())
        }
        .padding()
    }
    
    // MARK: - 邏輯函式區
    
    private func deleteTrip(at offsets: IndexSet) {
        for index in offsets {
            if trips[index].id == currentActiveTripID {
                stopActivity()
                currentActiveTripID = nil
            }
        }
        withAnimation { trips.remove(atOffsets: offsets) }
    }
    
    private func handleTripSelection(_ trip: Trip) {
        processingTripID = trip.id
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        Task {
            try? await Task.sleep(for: .seconds(0.1))
            startActivity(for: trip)
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                currentActiveTripID = trip.id
                processingTripID = nil
            }
        }
    }
    
    func startActivity(for trip: Trip) {
        let realDate = trip.actualDepartureDate // 直接拿計算好的絕對時間來用
        
        let attributes = TripAttributes(
            iconName: trip.iconName,
            isSystemImage: trip.isSystemImage,
            statusLabel: trip.statusLabel,
            transportName: trip.transportName,
            departureTime: trip.departureTime,
            arrivalTime: trip.arrivalTime,
            seatInfo: trip.seatInfo,
            terminalInfo: trip.terminalInfo,
            route: trip.route,
            estimatedTime: realDate,
            tintColor: trip.tintColor
        )
        let contentState = TripAttributes.ContentState(currentStatus: "準點", showCountdown: false, useDarkMode: useDarkMode)
        
        do {
            let newActivity = try Activity.request(attributes: attributes, content: .init(state: contentState, staleDate: nil))
            Task {
                for oldActivity in Activity<TripAttributes>.activities {
                    if oldActivity.id != newActivity.id { await oldActivity.end(dismissalPolicy: .immediate) }
                }
            }
        } catch { print("錯誤: \(error.localizedDescription)") }
    }
    
    func updateExistingActivity() {
        Task {
            for activity in Activity<TripAttributes>.activities {
                var newState = activity.content.state
                newState.useDarkMode = useDarkMode
                await activity.update(ActivityContent(state: newState, staleDate: nil))
            }
        }
    }
    
    func stopActivity() {
        let finalStatus = TripAttributes.ContentState(currentStatus: "已抵達", showCountdown: false, useDarkMode: useDarkMode)
        Task {
            for activity in Activity<TripAttributes>.activities {
                await activity.end(ActivityContent(state: finalStatus, staleDate: nil), dismissalPolicy: .immediate)
            }
        }
    }
}

// MARK: - 4.1 獨立出來的單行元件 (TripRowView)
struct TripRowView: View {
    let trip: Trip
    let isActive: Bool
    let isProcessing: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading) {
                    Text(trip.date)
                        .font(.caption).padding(4)
                        .background(trip.color.opacity(0.2))
                        .foregroundStyle(trip.color)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                    Text(trip.departureTime)
                        .font(.title3).bold().monospacedDigit()
                }
                .frame(width: 60, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        if trip.isSystemImage {
                            Image(systemName: trip.iconName).font(.caption).foregroundStyle(.secondary)
                        } else {
                            Image(trip.iconName).resizable().scaledToFit().frame(height: 16)
                        }
                        Text(trip.transportName).font(.headline).lineLimit(1)
                    }
                    Text(trip.route).font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                
                ZStack {
                    if isProcessing {
                        ProgressView().tint(.green).scaleEffect(1.2)
                    } else {
                        Image(systemName: isActive ? "checkmark.circle.fill" : "pin.circle.fill")
                            .font(.system(size: 30))
                            .foregroundStyle(isActive ? Color.green : Color.green.opacity(0.3))
                            .scaleEffect(isActive ? 1.2 : 1.0)
                    }
                }
                .frame(width: 32, height: 32)
                .animation(.spring, value: isActive)
                .animation(.easeInOut, value: isProcessing)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.vertical, 4)
    }
}

// MARK: - 其他共用元件與設定
struct BouncyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

enum TransportType: String, CaseIterable, Identifiable {
    case train = "火車"
    case airplane = "飛機"
    case bus = "巴士"
    var id: Self { self }
    var iconName: String {
        switch self { case .train: return "train.side.front.car"; case .airplane: return "airplane"; case .bus: return "bus.fill" }
    }
    var tintColor: String {
        switch self { case .train: return "c7ffd3"; case .airplane: return "FFA500"; case .bus: return "c7f9ff" }
    }
}

// MARK: - 5. 新增/編輯 共用表單
struct TripFormView: View {
    @Environment(\.dismiss) var dismiss
    
    var editingTrip: Trip?
    var onSave: (Trip) -> Void
    
    @State private var selectedTransport: TransportType = .train
    @State private var transportName: String = ""
    @State private var seatInfo: String = ""
    @State private var departurePoint: String = ""
    @State private var destinationPoint: String = ""
    
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date().addingTimeInterval(3600)
    
    // 🆕 表單綁定的時區選擇變數
    @State private var departureTimeZone: String = "Asia/Taipei"
    @State private var arrivalTimeZone: String = "Asia/Tokyo"
    
    var body: some View {
        NavigationStack {
            Form {
                Section("交通工具與班次") {
                    Picker("類型", selection: $selectedTransport) {
                        ForEach(TransportType.allCases) { type in Text(type.rawValue).tag(type) }
                    }
                    .pickerStyle(.segmented)
                    TextField("班次名稱 (例: 富士迴遊號 / NH854)", text: $transportName)
                    TextField("座位號碼 (例: 1號車 8D)", text: $seatInfo)
                }
                
                // 🆕 獨立的出發時間與時區設定
                Section("出發時間設定") {
                    Picker("出發時區", selection: $departureTimeZone) {
                        ForEach(commonTimeZones, id: \.0) { tz in
                            Text(tz.1).tag(tz.0)
                        }
                    }
                    DatePicker("當地時間", selection: $startTime)
                        .environment(\.timeZone, TimeZone(identifier: departureTimeZone) ?? .current)
                }
                
                // 🆕 獨立的抵達時間與時區設定
                Section("抵達時間設定") {
                    Picker("抵達時區", selection: $arrivalTimeZone) {
                        ForEach(commonTimeZones, id: \.0) { tz in
                            Text(tz.1).tag(tz.0)
                        }
                    }
                    DatePicker("當地時間", selection: $endTime)
                        .environment(\.timeZone, TimeZone(identifier: arrivalTimeZone) ?? .current)
                }
                
                Section("地點") {
                    TextField("出發地 (例: 東京)", text: $departurePoint)
                    TextField("目的地 (例: 河口湖)", text: $destinationPoint)
                }
            }
            .navigationTitle(editingTrip == nil ? "新增行程" : "編輯行程")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { Button("取消") { dismiss() } }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("儲存") { saveTrip() }
                    .disabled(transportName.isEmpty || departurePoint.isEmpty || destinationPoint.isEmpty)
                }
            }
            .onAppear {
                if let trip = editingTrip { loadExistingData(from: trip) }
            }
        }
    }
    
    private func loadExistingData(from trip: Trip) {
        transportName = trip.transportName
        seatInfo = trip.seatInfo == "-" ? "" : trip.seatInfo
        departureTimeZone = trip.departureTimeZone
        arrivalTimeZone = trip.arrivalTimeZone
        
        let routeParts = trip.route.components(separatedBy: " → ")
        if routeParts.count == 2 {
            departurePoint = routeParts[0]
            destinationPoint = routeParts[1]
        }
        
        if let matchedType = TransportType.allCases.first(where: { $0.iconName == trip.iconName }) {
            selectedTransport = matchedType
        } else if !trip.isSystemImage {
            selectedTransport = .airplane
        }
        
        // 讀取時需要依照各自的時區來還原 Date
        let depFmt = DateFormatter()
        depFmt.dateFormat = "yyyy/M/d HH:mm"
        depFmt.timeZone = TimeZone(identifier: departureTimeZone) ?? .current
        
        let arrFmt = DateFormatter()
        arrFmt.dateFormat = "yyyy/M/d HH:mm"
        arrFmt.timeZone = TimeZone(identifier: arrivalTimeZone) ?? .current
        
        if let sTime = depFmt.date(from: "\(trip.year)/\(trip.date) \(trip.departureTime)") { startTime = sTime }
        if let eTime = arrFmt.date(from: "\(trip.year)/\(trip.date) \(trip.arrivalTime)") { endTime = eTime }
    }
    
    private func saveTrip() {
        // 儲存時，分別使用使用者選定的時區把 Date 轉回字串
        let depYFmt = DateFormatter(); depYFmt.dateFormat = "yyyy"; depYFmt.timeZone = TimeZone(identifier: departureTimeZone) ?? .current
        let depDFmt = DateFormatter(); depDFmt.dateFormat = "M/d"; depDFmt.timeZone = TimeZone(identifier: departureTimeZone) ?? .current
        let depTFmt = DateFormatter(); depTFmt.dateFormat = "HH:mm"; depTFmt.timeZone = TimeZone(identifier: departureTimeZone) ?? .current
        
        let arrTFmt = DateFormatter(); arrTFmt.dateFormat = "HH:mm"; arrTFmt.timeZone = TimeZone(identifier: arrivalTimeZone) ?? .current
        
        let newTrip = Trip(
            id: editingTrip?.id ?? UUID(),
            year: depYFmt.string(from: startTime),
            date: depDFmt.string(from: startTime),
            iconName: selectedTransport.iconName,
            isSystemImage: true,
            statusLabel: selectedTransport == .airplane ? "起飛" : "發車",
            transportName: transportName,
            departureTime: depTFmt.string(from: startTime),
            arrivalTime: arrTFmt.string(from: endTime),
            seatInfo: seatInfo.isEmpty ? "-" : seatInfo,
            terminalInfo: "-",
            route: "\(departurePoint) → \(destinationPoint)",
            tintColor: selectedTransport.tintColor,
            departureTimeZone: departureTimeZone, // 🆕 寫入新的時區設定
            arrivalTimeZone: arrivalTimeZone      // 🆕 寫入新的時區設定
        )
        onSave(newTrip)
        dismiss()
    }
}

#Preview { ContentView() }
