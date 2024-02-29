import SwiftUI
import SwiftUI
import AVFoundation

let keypointThreshold:Float = 0.25 //改這個來修正對每個關節點判斷是否存在的閾值

enum DetectionState{
    case on
    case correcting
}

struct BodyDetectionView : View {
    @StateObject var lingual: LingualModel
    @StateObject var hunchbackDetection: HunchbackDetectModel

    @StateObject var userSettings: UserSettingsModel
    @State var showAlert = false
    @State var HBcount: Int = 0
    @State var runTime: Int = 0
    var perc: Double{
        return Double(HBcount*2)/Double(runTime*100)
    }
    
    @State var correctingIsrunning:Bool = false
    @State var detectionstate:DetectionState=DetectionState.on
    @State var targetDegreeThreshold:CGFloat = 80
    @State var sharedData = SharedData(keyPointThreshold: keypointThreshold)
    @State private var timerA: Timer? //update dection data
    @State private var countdownTimer: Timer?
    @State private var calibrationTimer: Timer?
    @State private var hunchbackStartTime: Date?
    @State var state: String?
    @State private var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        VStack{
            VStack{
                HStack(){
                    HStack(alignment: .center){
                        Button(action: {
                            self.detectionstate = .correcting
                        }) {
                            Image(systemName: "pencil.line").imageScale(.large).foregroundColor(.white).bold()
                        }.offset(x:10,y:10)
                        
                    }.frame(width: 150,height: 100).background(.green)
                    Spacer()
                    HStack{
                        Spacer()
                        VStack{
                            if(detectionstate==DetectionState.on){
                                Text(lingual.detectionMode).foregroundStyle(.secondary).font(.callout)
                            }else{
                                Text(lingual.correctionMode).foregroundStyle(.secondary).font(.callout)
                            }
                            Text(state ?? lingual.noTarget).font(.title)
                            
                        }
                        Spacer()
                    }.frame(width: UIScreen.main.bounds.width-300+30,height: 100).background(.red)
                    Spacer()
                    HStack(alignment: .center){
                        Button(action: {
                            sharedData.useFrontCamera.toggle()
                        }) {
                            Image(systemName: "arrow.triangle.2.circlepath.camera").imageScale(.large).foregroundColor(.white).bold()
                        }.offset(x:-10,y:10)
                    }.frame(width: 150,height: 100).background(.orange)
                    Spacer()
                }.frame(width: UIScreen.main.bounds.width,height: 100).background(.red)
                
                VideoView(sharedData: sharedData)
                    .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .overlay { 
                        VStack{
                            Text("\(lingual.youTotallyHave) \(perc)% \(lingual.timesHunchbacked)")
                                .foregroundColor(.white)
                            Text("\(lingual.hunchbackTotalCount): \(HBcount)")
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .offset(y:10)
                    }
                //Text("Time: \(hunchbackDetection.realtimeTotalCount)")
            }
        }
        .onAppear {
            // 创建并启动定时器
            startRunTime()
            var record:[CGFloat]=[]
            self.timerA = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                
                if(detectionstate==DetectionState.on){
                    // 如果 KPS 是字符串数组，打印它的内容
                    if !self.sharedData.KPS.isEmpty {
                        let status = check(kp: self.sharedData.KPS,threshold:targetDegreeThreshold)
                        switch status {
                        case 0:
                            self.hunchbackStartTime = nil
                            state = lingual.idle
                        case 1:
                            if self.hunchbackStartTime == nil {
                                self.hunchbackStartTime = Date()
                            } else if let startTime = self.hunchbackStartTime, Date().timeIntervalSince(startTime) >= 3 {
                                hunchbackStartTime = nil
                                playSound(source: "alarm", ext: "mp3")
                                hunchbackDetection.realtimeTotalCount += 1
                                HBcount += 1
                                checDailyGoal()
                            }
                            state = lingual.hunchback
                        case 2:
                            self.hunchbackStartTime = nil
                            state = lingual.sideways
                        default:
                            self.hunchbackStartTime = nil
                            state = lingual.noTarget
                        }
                    } else {
                        self.hunchbackStartTime = nil
                        state = lingual.noTarget
                    }
                }else{
                    if(!correctingIsrunning){
                        correctingIsrunning=true
                        startCountDown()
                    }
                    
                }
            }
        }
        .onDisappear {
            // 停止并废弃定时器
            self.calibrationTimer?.invalidate()
            self.calibrationTimer = nil
            self.timerA?.invalidate()
            self.timerA = nil
        }
        .alert(Text(lingual.hunchbackTooManyTimes), isPresented: $showAlert){
            Button("ok"){}
        }
    }
    
    
    func startRunTime(){
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ timer in
            if runTime < 1000{
                runTime += 1
            } else {
                timer.invalidate()
            }
        }
    }

    func checDailyGoal(){
        if HBcount >= userSettings.limitValuePublished{
            print("駝背超過每日限制次！")
            showAlert = true
        }
    }
    
    func startCountDown() {
        var countDown = 7 //能改
        var doEndJob:Bool = false
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if countDown > 0 {
                state = "\(lingual.correction) \(countDown) \(lingual.afterSecs)"
                playSound(source: "wait", ext: "mp3")
                countDown -= 1
            } else {
                countdownTimer?.invalidate()
                
                if(!doEndJob){
                    playSound(source: "start", ext: "mp3")
                    doEndJob = true
                    startCalibration()
                }
                
            }
        }
    }
    
    func startCalibration() {
        // 创建倒计时定时器
        var actionCheckCount:CGFloat = 0
        var sum:CGFloat=0
        var n:CGFloat=0
        var doEndJob:Bool = false
        calibrationTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if actionCheckCount < 50 {
                actionCheckCount += 1
                state = "\(lingual.leftover) \(actionCheckCount/10.0)/5 \(lingual.second)"
                if(checkTurnAround(kp: sharedData.KPS) == 0){
                    let angle = getTargetDegree(kp:sharedData.KPS)
                    if(angle != -1){
                        sum+=angle
                        n+=1
                    }
                }
            } else {
                // 倒计时结束，停止校正计时器，启动动作检测计时器
                calibrationTimer?.invalidate()
                
                if(!doEndJob){
                    doEndJob = true
                    print(sum,n)
                    if(n >= 30){
                        targetDegreeThreshold=sum/n
                    }
                    playSound(source: "finish", ext: "mp3")
                    detectionstate=DetectionState.on
                    correctingIsrunning = false
                }
            }
        }
        
    }
    
    func playSound(source:String,ext:String) {
        guard let soundURL = Bundle.main.url(forResource: source, withExtension: ext) else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("无法加载声音文件")
        }
    }
}
