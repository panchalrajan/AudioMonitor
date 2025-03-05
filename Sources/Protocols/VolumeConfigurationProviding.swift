//
//  VolumeConfigurationProviding.swift
//  AudioMonitor
//
//  Created by Rajan Panchal on 05/03/25.
//

import Foundation

public protocol VolumeConfigurationProviding {
    var silentModeCheckInterval: TimeInterval { get }
    var allowAppToSetSystemVolume: Bool { get }
    var volumeLockSettings: VolumeLockSettings { get }
    func unlockVolume() -> Self
}
