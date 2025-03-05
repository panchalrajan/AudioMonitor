//
//  SilentModeDetecting.swift
//  AudioMonitor
//
//  Created by Rajan Panchal on 05/03/25.
//

import Combine

public protocol SilentModeDetecting {
    func detectSilentMode() -> AnyPublisher<Bool, Never>
}
