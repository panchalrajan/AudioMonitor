//
//  AudioVolumeController.swift
//  AudioMonitor
//
//  Created by Rajan Panchal on 05/03/25.
//

import Combine
import MediaPlayer

public final class AudioVolumeController: AudioVolumeControlling {
    private let volumeSubject = CurrentValueSubject<Float, Never>(0.0)
    private(set) weak var systemSlider: UISlider?
    public var volumePublisher: AnyPublisher<Float, Never> {
        volumeSubject.eraseToAnyPublisher()
    }
    public func handleSystemSliderFound(slider: UISlider) {
        systemSlider = slider
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        refreshVolumeFromSystem()
    }
    public func setSystemVolume(_ volume: Float) {
        let clampedVolume = min(max(volume, 0.0), 1.0)
        systemSlider?.value = clampedVolume
        MPVolumeView.setVolume(clampedVolume)
        volumeSubject.send(clampedVolume)
    }
    public func refreshVolumeFromSystem() {
        guard let slider = systemSlider else { return }
        DispatchQueue.main.async {
            self.volumeSubject.send(slider.value)
        }
    }
    @objc private func sliderValueChanged(_ slider: UISlider) {
        volumeSubject.send(slider.value)
    }
}
