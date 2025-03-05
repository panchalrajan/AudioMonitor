//
//  AudioStatusProviding.swift
//  AudioMonitor
//
//  Created by Rajan Panchal on 05/03/25.
//

import Foundation

public protocol AudioStatusProviding {
    var volumePercentage: Int { get }
    var isSilentModeEnabled: Bool { get }
    var isVolumeZero: Bool { get }
    var isMuted: Bool { get }
    var outputRoute: AudioOutputRoute { get }
    var timestamp: Date { get }
}
