//
//  VolumeControlProviding.swift
//  AudioMonitor
//
//  Created by Rajan Panchal on 05/03/25.
//

import UIKit

public protocol VolumeControlProviding {
    static func setVolume(_ volume: Float)
    func findVolumeSlider() -> UISlider?
}
