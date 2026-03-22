import SwiftUI
import ActivityKit

// MARK: - 1. 資料模型
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

    var color: Color {
        switch tintColor {
        case "FFA500": return .orange
        case "c7f9ff": return .blue
        case "c7ffd3": return .green
        case "D3D3D3": return .gray
        default: return .primary
        }
    }
    
    var actualDepartureDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/M/d HH:mm"
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        return formatter.date(from: "\(year)/\(date) \(departureTime)") ?? Date.distantPast
    }
}

// MARK: - 2. 預設顯示資料 (初次打開 App 時顯示)
let defaultTrips: [Trip] = [
    Trip(year: "2026", date: "1/1", iconName: "hand.draw.fill", isSystemImage: true, statusLabel: "教學", transportName: "左滑刪除，右滑編輯", departureTime: "00:00", arrivalTime: "23:59", seatInfo: "-", terminalInfo: "-", route: "試著向左或向右滑動這張卡片", tintColor: "D3D3D3"),
    Trip(year: "2026", date: "4/1", iconName: "train.side.front.car", isSystemImage: true, statusLabel: "發車", transportName: "新幹線 (示範)", departureTime: "08:00", arrivalTime: "10:30", seatInfo: "3車 14A", terminalInfo: "-", route: "東京 → 大阪", tintColor: "c7ffd3"),
    Trip(year: "2026", date: "4/2", iconName: "airplane", isSystemImage: true, statusLabel: "起飛", transportName: "星宇航空 JX800 (示範)", departureTime: "08:30", arrivalTime: "12:45", seatInfo: "22A", terminalInfo: "T1 → T2", route: "台北(TPE) → 東京(NRT)", tintColor: "FFA500"),
    Trip(year: "2026", date: "4/3", iconName: "bus.fill", isSystemImage: true, statusLabel: "發車", transportName: "高速巴士 (示範)", departureTime: "09:00", arrivalTime: "11:00", seatInfo: "1A", terminalInfo: "-", route: "新宿 → 河口湖", tintColor: "c7f9ff")
]

// MARK: - 2.1 日本行程範例資料庫 (手動載入用)
let japanTrips: [Trip] = [
    Trip(year: "2025", date: "12/16", iconName: "train.side.front.car", isSystemImage: true, statusLabel: "發車", transportName: "富士迴遊號 (JR)", departureTime: "18:10", arrivalTime: "19:00", seatInfo: "7A", terminalInfo: "-", route: "東京 → スカイツリー", tintColor: "c7ffd3"),
    Trip(year: "2026", date: "1/8", iconName: "ana_logo", isSystemImage: false, statusLabel: "起飛", transportName: "NH854 (ANA)", departureTime: "16:50", arrivalTime: "20:40", seatInfo: "14B", terminalInfo: "T1 → T2", route: "台北(松山) → 東京(羽田)", tintColor: "FFA500"),
    Trip(year: "2026", date: "1/10", iconName: "train.side.front.car", isSystemImage: true, statusLabel: "發車", transportName: "富士迴遊號 (JR)", departureTime: "07:07", arrivalTime: "09:28", seatInfo: "1號車 8D", terminalInfo: "-", route: "錦糸町 → 河口湖", tintColor: "c7ffd3"),
    Trip(year: "2026", date: "1/11", iconName: "bus.fill", isSystemImage: true, statusLabel: "發車", transportName: "高速巴士 2030便", departureTime: "10:20", arrivalTime: "12:30", seatInfo: "1號車 6A/6B", terminalInfo: "-", route: "河口湖 → 澀谷", tintColor: "c7f9ff"),
    Trip(year: "2026", date: "1/13", iconName: "ana_logo", isSystemImage: false, statusLabel: "起飛", transportName: "NH019 (ANA)", departureTime: "10:00", arrivalTime: "11:10", seatInfo: "30B", terminalInfo: "T2 → T1", route: "東京(羽田) → 大阪(伊丹)", tintColor: "FFA500"),
    Trip(year: "2026", date: "1/13", iconName: "ana_logo", isSystemImage: false, statusLabel: "起飛", transportName: "NH735 (ANA)", departureTime: "12:30", arrivalTime: "13:50", seatInfo: "6D", terminalInfo: "T1 → T1", route: "大阪(伊丹) → 仙台", tintColor: "FFA500"),
    Trip(year: "2026", date: "1/17", iconName: "ana_logo", isSystemImage: false, statusLabel: "起飛", transportName: "NH1229 (ANA)", departureTime: "17:20", arrivalTime: "18:35", seatInfo: "15K", terminalInfo: "T1 → D", route: "仙台 → 札幌(新千歲)", tintColor: "FFA500"),
    Trip(year: "2026", date: "1/23", iconName: "ana_logo", isSystemImage: false, statusLabel: "起飛", transportName: "NH054 (ANA)", departureTime: "09:30", arrivalTime: "11:10", seatInfo: "41K", terminalInfo: "D → T2", route: "札幌(新千歲) → 東京(羽田)", tintColor: "FFA500"),
    Trip(year: "2026", date: "1/23", iconName: "ana_logo", isSystemImage: false, statusLabel: "起飛", transportName: "NH853 (ANA)", departureTime: "12:40", arrivalTime: "15:50", seatInfo: "29F", terminalInfo: "T2 → T1", route: "東京(羽田) → 台北(松山)", tintColor: "FFA500")
]

// MARK: - 3. 主畫面
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
            VStack {
                headerView
                tripList
                bottomButtons
            }
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
                            // 載入日本行程
                            Button(role: .destructive) {
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.impactOccurred()
                                withAnimation {
                                    trips = japanTrips.sorted { $0.actualDepartureDate < $1.actualDepartureDate }
                                }
                            } label: {
                                Label("載入日本行程範例", systemImage: "map.fill")
                            }
                            
                            // 還原成只有 4 張卡片的預設狀態
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
                        Image(systemName: "gearshape.fill").font(.title3).foregroundStyle(.gray)
                    }
                }
            }
            .onAppear {
                if let decoded = try? JSONDecoder().decode([Trip].self, from: savedTripsData), !decoded.isEmpty {
                    trips = decoded.sorted { $0.actualDepartureDate < $1.actualDepartureDate }
                } else {
                    // 🆕 第一次打開，載入乾淨的 4 張預設卡片
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
    
    private var headerView: some View {
        HStack {
            Image(systemName: "map.fill").foregroundStyle(.blue)
            Text("交通提醒小助手").font(.largeTitle).bold()
        }
        .padding(.top)
    }
    
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
        withAnimation {
            trips.remove(atOffsets: offsets)
        }
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
    
    func parseDate(trip: Trip) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/M/d HH:mm"
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        if let date = formatter.date(from: "\(trip.year)/\(trip.date) \(trip.departureTime)") { return date }
        return Date()
    }
    
    func startActivity(for trip: Trip) {
        let realDate = parseDate(trip: trip)
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

// MARK: - 3.1 獨立出來的單行元件 (TripRowView)
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
                Section("時間 (以日本時間為準)") {
                    DatePicker("出發時間", selection: $startTime)
                    DatePicker("抵達時間", selection: $endTime)
                }
                .environment(\.timeZone, TimeZone(identifier: "Asia/Tokyo")!)
                
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
                if let trip = editingTrip {
                    loadExistingData(from: trip)
                }
            }
        }
    }
    
    private func loadExistingData(from trip: Trip) {
        transportName = trip.transportName
        seatInfo = trip.seatInfo == "-" ? "" : trip.seatInfo
        
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
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/M/d HH:mm"
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        
        if let sTime = formatter.date(from: "\(trip.year)/\(trip.date) \(trip.departureTime)") {
            startTime = sTime
        }
        if let eTime = formatter.date(from: "\(trip.year)/\(trip.date) \(trip.arrivalTime)") {
            endTime = eTime
        }
    }
    
    private func saveTrip() {
        let yFmt = DateFormatter(); yFmt.dateFormat = "yyyy"; yFmt.timeZone = TimeZone(identifier: "Asia/Tokyo")
        let dFmt = DateFormatter(); dFmt.dateFormat = "M/d"; dFmt.timeZone = TimeZone(identifier: "Asia/Tokyo")
        let tFmt = DateFormatter(); tFmt.dateFormat = "HH:mm"; tFmt.timeZone = TimeZone(identifier: "Asia/Tokyo")
        
        let newTrip = Trip(
            id: editingTrip?.id ?? UUID(),
            year: yFmt.string(from: startTime), date: dFmt.string(from: startTime),
            iconName: selectedTransport.iconName, isSystemImage: true,
            statusLabel: selectedTransport == .airplane ? "起飛" : "發車",
            transportName: transportName, departureTime: tFmt.string(from: startTime), arrivalTime: tFmt.string(from: endTime),
            seatInfo: seatInfo.isEmpty ? "-" : seatInfo, terminalInfo: "-", route: "\(departurePoint) → \(destinationPoint)",
            tintColor: selectedTransport.tintColor
        )
        onSave(newTrip)
        dismiss()
    }
}

#Preview { ContentView() }
