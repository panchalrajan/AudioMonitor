//
//  AudioMonitoring.swift
//  AudioMonitor
//
//  Created by Rajan Panchal on 05/03/25.
//

import Combine
import UIKit

public protocol AudioMonitoring {
    var audioStatusPublisher: AnyPublisher<AudioStatus, Never> { get }
    var currentAudioStatus: AudioStatus { get }
    func updateConfig(newConfig: VolumeConfiguration)
    func startMonitoring()
    func stopMonitoring()
    func checkNow()
    func setVolume(_ percentage: Int)
    func handleSystemSliderFound(slider: UISlider)
}

