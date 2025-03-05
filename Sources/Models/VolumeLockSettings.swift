//
//  VolumeLockSettings.swift
//  AudioMonitor
//
//  Created by Rajan Panchal on 05/03/25.
//

import Foundation

public struct VolumeLockSettings: VolumeLockSettingsProviding, Equatable {
    public let minVolume: Int
    public let maxVolume: Int
    public let isLocked: Bool
    public init(minVolume: Int, maxVolume: Int, isLocked: Bool = false) {
        self.minVolume = min(minVolume, 100)
        self.maxVolume = max(min(maxVolume, 100), self.minVolume)
        self.isLocked = isLocked
    }
}
