//
//  View+Extensions.swift
//  AudioMonitor
//
//  Created by Rajan Panchal on 05/03/25.
//

import SwiftUI

public extension View {
    func addVolumeMontior(configuration: VolumeConfiguration = .default) -> some View {
        modifier(VolumeListenerModifier(configuration: configuration))
    }
}
