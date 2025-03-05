//
//  AudioStatus.swift
//  AudioMonitor
//
//  Created by Rajan Panchal on 05/03/25.
//

import Foundation

public struct AudioStatus: AudioStatusProviding, Equatable {
    public let volumePercentage: Int
    public let isSilentModeEnabled: Bool
    public let isVolumeZero: Bool
    public let isMuted: Bool
    public let outputRoute: AudioOutputRoute
    public let timestamp: Date
    
    public init(volumePercentage: Int, isSilentModeEnabled: Bool) {
        self.volumePercentage = max(0, min(volumePercentage, 100))
        self.isSilentModeEnabled = isSilentModeEnabled
        self.isVolumeZero = self.volumePercentage == 0
        self.isMuted = isSilentModeEnabled || self.isVolumeZero
        self.outputRoute = AudioOutputRoute.current()
        self.timestamp = Date()
    }
}
