//
//  VolumeListenerModifier.swift
//  AudioMonitor
//
//  Created by Rajan Panchal on 05/03/25.
//

import SwiftUI

public struct VolumeListenerModifier: ViewModifier {
    private let configuration: VolumeConfiguration
    public init(configuration: VolumeConfiguration = .default) {
        self.configuration = configuration
    }
    public func body(content: Content) -> some View {
        content
            .overlay(
                SystemVolumeView { slider in
                    AudioMonitor.shared.handleSystemSliderFound(slider: slider)
                }
                    .frame(width: 0, height: 0)
                    .hidden()
            )
            .onAppear {
                AudioMonitor.shared.startMonitoring()
            }
            .onDisappear {
                AudioMonitor.shared.stopMonitoring()
            }
    }
}
