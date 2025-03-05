//
//  AudioOutputRoute+Extensions.swift
//  AudioMonitor
//
//  Created by Rajan Panchal on 05/03/25.
//

import AVFoundation

extension AudioOutputRoute: AudioOutputRouteProviding {
    public static func current() -> Self {
        let audioSession = AVAudioSession.sharedInstance()
        guard let output = audioSession.currentRoute.outputs.first(where: { _ in true }) else {
            return .unknown
        }
        
        switch output.portType {
            case .builtInSpeaker:
                return .speaker
            case .headphones, .headsetMic:
                return .headphones
            case .bluetoothA2DP, .bluetoothLE, .bluetoothHFP:
                return .bluetooth(deviceName: output.portName, batteryLevel: fetchBluetoothBatteryLevel(from: output))
            default:
                return .unknown
        }
    }
    private static func fetchBluetoothBatteryLevel(from output: AVAudioSessionPortDescription) -> Int? {
        let batteryLevel = output.value(forKey: "batteryLevel") as? Float
        return batteryLevel.map { Int($0 * 100) }
    }
}
