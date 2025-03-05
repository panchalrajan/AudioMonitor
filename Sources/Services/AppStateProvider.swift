//
//  AppStateProvider.swift
//  AudioMonitor
//
//  Created by Rajan Panchal on 05/03/25.
//

import Combine
import UIKit

public final class AppStateProvider: AppStateProviding {
    public static let shared = AppStateProvider()
    private var appStateSubject: CurrentValueSubject<AppState, Never>
    private var cancellables = Set<AnyCancellable>()
    public var appStatePublisher: AnyPublisher<AppState, Never> {
        appStateSubject.eraseToAnyPublisher()
    }
    public var currentAppState: AppState {
        appStateSubject.value
    }
    private init() {
        appStateSubject = CurrentValueSubject(Self.mapApplicationState(UIApplication.shared.applicationState))
        setupObservers()
    }
    private func setupObservers() {
        let notificationPublishers = [
            (UIApplication.didBecomeActiveNotification, AppState.active),
            (UIApplication.willResignActiveNotification, AppState.inactive),
            (UIApplication.didEnterBackgroundNotification, AppState.background)
        ]
        
        notificationPublishers.forEach { (notification, state) in
            NotificationCenter.default.publisher(for: notification)
                .sink { [weak self] _ in
                    self?.appStateSubject.send(state)
                }
                .store(in: &cancellables)
        }
    }
    public static func mapApplicationState(_ state: UIApplication.State) -> AppState {
        switch state {
            case .active: return .active
            case .inactive: return .inactive
            case .background: return .background
            @unknown default: return .inactive
        }
    }
}
