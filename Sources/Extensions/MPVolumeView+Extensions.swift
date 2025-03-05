//
//  MPVolumeView+Extensions.swift
//  AudioMonitor
//
//  Created by Rajan Panchal on 05/03/25.
//

import MediaPlayer

extension MPVolumeView: VolumeControlProviding {
    public static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            slider?.value = volume
        }
    }
    public func findVolumeSlider() -> UISlider? {
        return subviews.first { $0 is UISlider } as? UISlider
    }
}
