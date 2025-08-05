//
//  ContentView.swift
//  focus
//
//  Created by blacksnow on 8/4/25.
//

import SwiftUI


struct ContentView: View {
    private enum TimerStatus {
        case timerFocus
        case timerBreak
        case timerIdle
        
        var title: String {
            switch self {
                case .timerIdle:
                    return "Timer is Idle"
                case .timerFocus:
                    return "Focus time"
                case .timerBreak:
                    return "Break time"
            }
        }
    }
    
    @State var timeRemaining: CGFloat = 10
    let timer = Timer.publish(
        every: 1 / Constants.frameRate,
        on: .main,
        in: .common
    ).autoconnect()
    
    @State private var currentStatus: TimerStatus = .timerIdle
    
    private let formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        
        return formatter
    }()
    
    var body: some View {
        VStack {
            
            Text(currentStatus.title).font(.title)
            Spacer()
            
            if currentStatus != .timerIdle {
                Text(formatter.string(from: timeRemaining) ?? "00:00").font(.largeTitle)
                    .onReceive(timer, perform: {
                        _ in
                        if timeRemaining > 0 {
                            timeRemaining -= 1 / Constants.frameRate
                        } else {
                            stopAll()
                        }
                })
                
                Spacer()
            }
            
            switch currentStatus {
            case .timerFocus:
                Button(action: startBreak) {
                    Text("Start Break")
                }
                Button(action: stopAll) {
                    Text("Stop all")
                }
            case .timerIdle:
                Button(action: startFocus) {
                    Text("Start Focus")
                }
            case .timerBreak:
                Button(action: startFocus) {
                    Text("Start Focus")
                }
                Button(action: stopAll) {
                    Text("Stop all")
                }
            }
            Spacer()
        }
        .padding()
    }
    
    private func startFocus() {
        currentStatus = .timerFocus
        timeRemaining = Constants.focusTime
    }
    
    private func startBreak() {
        currentStatus = .timerBreak
        timeRemaining = Constants.breakTime
    }
    
    private func stopAll() {
        currentStatus = .timerIdle
    }
}

#Preview {
    ContentView()
}

private enum Constants {
    static let frameRate: CGFloat = 120
    static let focusTime: CGFloat = 60 * 25
    static let breakTime: CGFloat = 60 * 5
}
