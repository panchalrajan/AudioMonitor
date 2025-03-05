# AudioMonitor 🎧
[![Swift Version](https://img.shields.io/badge/Swift-5.3+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-iOS-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

A powerful Swift library for comprehensive audio and volume management in iOS applications.

## Overview

AudioMonitor provides an elegant solution for monitoring and controlling system audio, including:
- Volume tracking
- Silent mode detection
- Audio output route monitoring
- Volume locking and restrictions

## Features

- 📊 Real-time volume percentage tracking
- 🔇 Silent mode detection
- 🎧 Audio output route identification (Speaker, Headphones, Bluetooth)
- 🔒 Volume range locking
- 🔄 Reactive programming with Combine
- 📱 App state awareness

## Requirements

- iOS 13.0+
- Swift 5.3+
- Xcode 12.0+

## Installation

### Swift Package Manager
Add this package to your Xcode project using Swift Package Manager:

1. In Xcode, select `File` → `Add Packages...`
2. Enter the package URL: `https://github.com/panchalrajan/AudioMonitor.git`
3. Choose `Up to Next Major Version` with `1.0.0`

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/panchalrajan/AudioMonitor.git", from: "1.0.0")
]
```

## Quick Start

Add `.addVolumeMonitor` at root level, this will automatically starts the monitoring, you can also pass the `configuration` in this extension
```swift
@main
struct AudioMonitorApp: App {
    var body: some Scene {
        WindowGroup {
            AudioMonitorDemoView()
                .addVolumeMonitor()
        }
    }
}
```

Basic Implementation
```swift
import AudioMonitor

// Subscribe to audio status changes
AudioMonitor.shared.audioStatusPublisher
    .sink { audioStatus in
        print("Volume: \(audioStatus.volumePercentage)%")
        print("Silent Mode: \(audioStatus.isSilentModeEnabled)")
        print("Output Route: \(audioStatus.outputRoute.description)")
    }
    .store(in: &cancellables)

// Set volume with restrictions
AudioMonitor.shared.setVolume(50)

// Stop monitoring
AudioMonitor.shared.stopMonitoring()
```

## Configuration

```swift
// Custom volume configuration
let config = VolumeConfiguration(
    silentModeCheckInterval: 2.0,
    allowAppToSetSystemVolume: true,
    volumeLockSettings: VolumeLockSettings(minVolume: 20, maxVolume: 80)
)
AudioMonitor.shared.updateConfig(newConfig: config)
```

## Limitations

- Only supports iOS devices
- Silent mode detection relies on playing a short sound file
- Bluetooth battery level detection may not work for all devices

## TODO

- [ ] Add comprehensive unit and UI test coverage
- [ ] Create more extensive documentation
- [ ] Add support for watchOS and macOS
- [ ] Create example apps demonstrating various use cases

## Common Issues

1. Volume not tracking correctly
   - Verify you have added `.addVolumeListener` at root level
   - Check audio session configuration

2. System Volume not changing
   - Ensure `allowAppToSetSystemVolume` is set to true
   
## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

Distributed under the MIT License. See `LICENSE` for more information.

## Contact

Linkedin : [@panchalrajan](https://www.linkedin.com/in/panchalrajan/)

Project Link: [AudioMonitor](https://github.com/panchalrajan/AudioMonitor)

## Acknowledgments

- Swift Programming Community
- Combine Framework
- iOS Audio APIs
- [Mute by akramhussein](https://github.com/akramhussein/Mute)
  
## Disclaimer

This library is provided as-is. Always test thoroughly in your specific use case.

## Version History

- 1.0.0: Initial release


## Support
For issues, feature requests, or support, please [[create an issue in the repository](https://github.com/panchalrajan/AudioMonitor/issues)].
