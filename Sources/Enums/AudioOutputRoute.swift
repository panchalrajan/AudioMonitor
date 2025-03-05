//
//  AudioOutputRoute.swift
//  AudioMonitor
//
//  Created by Rajan Panchal on 05/03/25.
//

import Foundation

public enum AudioOutputRoute: Equatable {
    case speaker
    case headphones
    case bluetooth(deviceName: String?, batteryLevel: Int?)
    case unknown

    var description: String {
        switch self {
        case .speaker:
            return "Speaker"
        case .headphones:
            return "Headphones"
        case .bluetooth(let deviceName, _):
            return "Bluetooth: \(deviceName ?? "Unknown Device")"
        case .unknown:
            return "Unknown Output"
        }
    }
}
