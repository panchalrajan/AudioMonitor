//
//  SystemVolumeViewProviding.swift
//  AudioMonitor
//
//  Created by Rajan Panchal on 05/03/25.
//

import MediaPlayer

public protocol SystemVolumeViewProviding {
    func createVolumeView(sliderFoundCallback: @escaping (UISlider) -> Void) -> MPVolumeView
}
