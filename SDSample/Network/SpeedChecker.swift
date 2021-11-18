//
//  SpeedChecker.swift
//  SDSample
//
//  Created by Stroh, Eric J. on 11/17/21.
//

import Foundation

extension Notification.Name {
    static let didRecieveData = Notification.Name("didReceiveData")
}

// This class is the observable for the main SwiftUI view
class SpeedChecker: ObservableObject {
    
    @Published private(set) var speed = "0.0"
    @Published private(set) var networkStatus = ConnectionType.unknown
    
    private let speedService = SpeedService()
    private let network = NetworkStatus.shared
    
    public init() {
        fetchSpeed()
        network.start()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onDidReceiveData(_:)),
                                               name: .didRecieveData, object: nil)
    }
}

extension SpeedChecker {
    func fetchSpeed() {
        speedService.load()
    }
    
    /// This class handles change to the speed notification
    /// - Parameters:
    ///   - notification: the notification when a new speed has been calculated or an error occurs.
    @objc func onDidReceiveData(_ notification: Notification) {
        if let data = notification.userInfo as? [String: Double] {
            for (status, value) in data {
                let displayValue = status == "error" ? "error" : String(format: "%.2f", value)
                DispatchQueue.main.async { [weak self] in
                    self?.speed = displayValue
                }
            }
        }
        // repeatedly fetch the speed
        fetchSpeed()
    }
}
