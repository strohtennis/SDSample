//
//  NetworkStatus.swift
//  SDSample
//
//  Created by Stroh, Eric J. on 11/17/21.
//  mostly copied from: https://en.proft.me/2020/04/27/detect-network-status-swift/
//

import Network

public enum ConnectionType {
    case wifi
    case ethernet
    case cellular
    case unknown
}
extension ConnectionType {
    func description() -> String {
        switch self {
        case .wifi: return "wifi"
        case .ethernet: return "ethernet"
        case .cellular: return "cellular"
        default: return "unknown"
        }
    }
}

/// This class checks for internet connectivity and the type of connection
class NetworkStatus {
    static public let shared = NetworkStatus()
    private var monitor: NWPathMonitor
    private var queue = DispatchQueue.global()
    var isOn: Bool = true
    var connType: ConnectionType = .wifi

    private init() {
        self.monitor = NWPathMonitor()
        self.queue = DispatchQueue.global(qos: .background)
        self.monitor.start(queue: queue)
    }

    func start() {
        self.monitor.pathUpdateHandler = { path in
            self.isOn = path.status == .satisfied
            self.connType = self.checkConnectionTypeForPath(path)
        }
    }

    func checkConnectionTypeForPath(_ path: NWPath) -> ConnectionType {
        if path.usesInterfaceType(.wifi) {
            return .wifi
        } else if path.usesInterfaceType(.wiredEthernet) {
            return .ethernet
        } else if path.usesInterfaceType(.cellular) {
            return .cellular
        }

        return .unknown
    }
}
