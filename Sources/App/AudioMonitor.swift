//
//  AudioMonitor.swift
//  AudioMonitor
//
//  Created by Rajan Panchal on 05/03/25.
//

import Combine
import UIKit

public final class AudioMonitor: AudioMonitoring {
    public static let shared = AudioMonitor()
    private let volumeController: AudioVolumeControlling
    private let silentModeDetector: SilentModeDetecting
    private let appStateProvider: AppStateProviding
    private(set) var configuration: VolumeConfigurationProviding
    private var oneTimeCancellables = Set<AnyCancellable>()
    private var monitoringCancellables = Set<AnyCancellable>()
    private let audioStatusSubject = CurrentValueSubject<AudioStatus, Never>(
        AudioStatus(volumePercentage: 0, isSilentModeEnabled: false)
    )
    private var silentModeTimer: AnyCancellable?
    private(set) var isMonitoring = false
    public var audioStatusPublisher: AnyPublisher<AudioStatus, Never> {
        audioStatusSubject.eraseToAnyPublisher()
    }
    public var currentAudioStatus: AudioStatus {
        audioStatusSubject.value
    }
    init(volumeController: AudioVolumeControlling = AudioVolumeController(),
         silentModeDetector: SilentModeDetecting = SilentModeDetector(),
         appStateProvider: AppStateProviding = AppStateProvider.shared,
         configuration: VolumeConfiguration = .default) {
        self.volumeController = volumeController
        self.silentModeDetector = silentModeDetector
        self.appStateProvider = appStateProvider
        self.configuration = configuration
    }
    public func updateConfig(newConfig: VolumeConfiguration) {
        self.configuration = newConfig
        if isMonitoring {
            scheduleSilentModeChecks()
        }
    }
    public func getConfig() -> VolumeConfigurationProviding {
        configuration
    }
    public func startMonitoring() {
        guard !isMonitoring else { return }
        isMonitoring = true
        
        setupObservers()
        scheduleSilentModeChecks()
        checkNow()
    }
    public func stopMonitoring() {
        isMonitoring = false
        monitoringCancellables.removeAll()
        silentModeTimer?.cancel()
        silentModeTimer = nil
    }
    public func checkNow() {
        guard appStateProvider.currentAppState == .active else { return }
        volumeController.refreshVolumeFromSystem()
        
        if !isMonitoring {
            volumeController.volumePublisher
                .first()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] volume in
                    self?.updateAudioStatus(volume: volume)
                }
                .store(in: &oneTimeCancellables)
            
            silentModeDetector.detectSilentMode()
                .first()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] isSilent in
                    self?.updateAudioStatus(isSilent: isSilent)
                }
                .store(in: &oneTimeCancellables)
        }
    }
    public func unlockVolume() {
        configuration = configuration.unlockVolume()
    }
    public func setVolume(_ percentage: Int) {
        guard configuration.allowAppToSetSystemVolume else { return }
        let normalizedVolume = configuration.volumeLockSettings.isLocked
        ? min(max(percentage, configuration.volumeLockSettings.minVolume), configuration.volumeLockSettings.maxVolume)
        : percentage
        let volumeFloat = Float(normalizedVolume) / 100.0
        volumeController.setSystemVolume(volumeFloat)
    }
    public func handleSystemSliderFound(slider: UISlider) {
        volumeController.handleSystemSliderFound(slider: slider)
    }
    private func setupObservers() {
        appStateProvider.appStatePublisher
            .sink { [weak self] state in
                guard let self = self else { return }
                
                switch state {
                    case .active:
                        self.resumeMonitoring()
                        self.enforceVolumeLimits()
                    case .inactive, .background:
                        self.pauseMonitoring()
                }
            }
            .store(in: &monitoringCancellables)
        volumeController.volumePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] volume in
                // Update audio status with new volume
                self?.updateAudioStatus(volume: volume)
                // Enforce volume limits on each volume change
                self?.enforceVolumeLimits()
            }
            .store(in: &monitoringCancellables)
    }
    private func enforceVolumeLimits() {
        guard configuration.volumeLockSettings.isLocked else { return }
        let currentVolume = currentAudioStatus.volumePercentage
        let volumeLockSettings = configuration.volumeLockSettings
        if currentVolume < volumeLockSettings.minVolume {
            setVolume(volumeLockSettings.minVolume)
        }
        else if currentVolume > volumeLockSettings.maxVolume {
            setVolume(volumeLockSettings.maxVolume)
        }
    }
    private func resumeMonitoring() {
        scheduleSilentModeChecks()
        checkNow()
    }
    private func pauseMonitoring() {
        silentModeTimer?.cancel()
        silentModeTimer = nil
    }
    private func scheduleSilentModeChecks() {
        silentModeTimer?.cancel()
        silentModeTimer = Timer.publish(
            every: configuration.silentModeCheckInterval,
            on: .main,
            in: .common
        )
        .autoconnect()
        .filter { [weak self] _ in
            self?.appStateProvider.currentAppState == .active
        }
        .sink { [weak self] _ in
            self?.checkSilentMode()
        }
    }
    private func checkSilentMode() {
        silentModeDetector.detectSilentMode()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSilent in
                self?.updateAudioStatus(isSilent: isSilent)
            }
            .store(in: &monitoringCancellables)
    }
    private func updateAudioStatus(volume: Float? = nil, isSilent: Bool? = nil) {
        let currentVolume = volume ?? Float(audioStatusSubject.value.volumePercentage) / 100.0
        let currentSilentMode = isSilent ?? audioStatusSubject.value.isSilentModeEnabled
        let volumePercentage = Int(currentVolume * 100)
        let newStatus = AudioStatus(
            volumePercentage: volumePercentage,
            isSilentModeEnabled: currentSilentMode
        )
        guard newStatus != currentAudioStatus else { return }
        audioStatusSubject.send(newStatus)
    }
    deinit {
        stopMonitoring()
    }
}
