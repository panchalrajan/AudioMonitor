//
//  VolumeLockSettingsProviding.swift
//  AudioMonitor
//
//  Created by Rajan Panchal on 05/03/25.
//

import Foundation

public protocol VolumeLockSettingsProviding {
    var minVolume: Int { get }
    var maxVolume: Int { get }
    var isLocked: Bool { get }
}
