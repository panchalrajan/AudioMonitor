//
//  SystemVolumeView.swift
//  AudioMonitor
//
//  Created by Rajan Panchal on 05/03/25.
//

import MediaPlayer
import SwiftUI
import UIKit

public struct SystemVolumeView: UIViewRepresentable, SystemVolumeViewProviding {
    private let sliderFoundCallback: (UISlider) -> Void
    public init(sliderFoundCallback: @escaping (UISlider) -> Void) {
        self.sliderFoundCallback = sliderFoundCallback
    }
    public func makeUIView(context: Context) -> MPVolumeView {
        return createVolumeView(sliderFoundCallback: sliderFoundCallback)
    }
    public func createVolumeView(sliderFoundCallback: @escaping (UISlider) -> Void) -> MPVolumeView {
        let volumeView = MPVolumeView(frame: .zero)
        volumeView.alpha = 0.01
        if let slider = volumeView.findVolumeSlider() {
            sliderFoundCallback(slider)
        }
        return volumeView
    }
    public func updateUIView(_ uiView: MPVolumeView, context: Context) {}
}
