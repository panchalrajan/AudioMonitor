//
//  AppStateProviding.swift
//  AudioMonitor
//
//  Created by Rajan Panchal on 05/03/25.
//

import Combine

public protocol AppStateProviding: AnyObject {
    var appStatePublisher: AnyPublisher<AppState, Never> { get }
    var currentAppState: AppState { get }
}
