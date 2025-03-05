//
//  VolumeConfiguration.swift
//  AudioMonitor
//
//  Created by Rajan Panchal on 05/03/25.
//

import Foundation

public struct VolumeConfiguration: VolumeConfigurationProviding {
    public let silentModeCheckInterval: TimeInterval
    public let allowAppToSetSystemVolume: Bool
    public let volumeLockSettings: VolumeLockSettings
    public init(
        silentModeCheckInterval: TimeInterval,
        allowAppToSetSystemVolume: Bool,
        volumeLockSettings: VolumeLockSettings = VolumeLockSettings(minVolume: 20, maxVolume: 80)
    ) {
        self.silentModeCheckInterval = silentModeCheckInterval
        self.allowAppToSetSystemVolume = allowAppToSetSystemVolume
        self.volumeLockSettings = volumeLockSettings
    }
    
    public static let `default` = VolumeConfiguration(
        silentModeCheckInterval: 2.0,
        allowAppToSetSystemVolume: true,
        volumeLockSettings: VolumeLockSettings(minVolume: 20, maxVolume: 80)
    )
    public func unlockVolume() -> VolumeConfiguration {
        VolumeConfiguration(
            silentModeCheckInterval: silentModeCheckInterval,
            allowAppToSetSystemVolume: allowAppToSetSystemVolume,
            volumeLockSettings: VolumeLockSettings(
                minVolume: volumeLockSettings.minVolume,
                maxVolume: volumeLockSettings.maxVolume,
                isLocked: false
            )
        )
    }
}
