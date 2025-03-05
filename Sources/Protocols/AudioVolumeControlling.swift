//
//  AudioVolumeControlling.swift
//  AudioMonitor
//
//  Created by Rajan Panchal on 05/03/25.
//

import Combine
import UIKit

public protocol AudioVolumeControlling: AnyObject {
    var volumePublisher: AnyPublisher<Float, Never> { get }
    func setSystemVolume(_ volume: Float)
    func handleSystemSliderFound(slider: UISlider)
    func refreshVolumeFromSystem()
}
