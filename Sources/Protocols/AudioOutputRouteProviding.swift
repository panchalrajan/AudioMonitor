//
//  AudioOutputRouteProviding.swift
//  AudioMonitor
//
//  Created by Rajan Panchal on 05/03/25.
//

import Foundation

public protocol AudioOutputRouteProviding {
    static func current() -> AudioOutputRoute
}
