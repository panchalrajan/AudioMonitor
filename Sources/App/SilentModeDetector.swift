//
//  SilentModeDetector.swift
//  AudioMonitor
//
//  Created by Rajan Panchal on 05/03/25.
//

import AVFoundation
import Combine

public final class SilentModeDetector: SilentModeDetecting {
    private let appStateProvider: AppStateProviding
    private var soundId: SystemSoundID?
    
    public init(appStateProvider: AppStateProviding = AppStateProvider.shared) {
        self.appStateProvider = appStateProvider
        if let url = Bundle.module.url(forResource: "mute", withExtension: "aiff") {
            var soundId: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(url as CFURL, &soundId)
            self.soundId = soundId
        }
    }
    
    deinit {
        if let soundId = soundId {
            AudioServicesDisposeSystemSoundID(soundId)
        }
    }
    
    public func detectSilentMode() -> AnyPublisher<Bool, Never> {
        guard appStateProvider.currentAppState == .active,
              let soundId = soundId else {
            return Just(false).eraseToAnyPublisher()
        }
        
        return Future<Bool, Never> { promise in
            let startTime = CFAbsoluteTimeGetCurrent()
            AudioServicesPlaySystemSoundWithCompletion(soundId) {
                let elapsed = CFAbsoluteTimeGetCurrent() - startTime
                DispatchQueue.main.async {
                    promise(.success(elapsed < 0.1))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
