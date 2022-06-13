//
//  NetworkMonitor.swift
//  Picture_of_The_Day
//
//  Created by Hegde, Prajna on 12/06/22.
//

import Foundation
import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool {
        status == .satisfied
        
    }
    var isReachableOnCellular: Bool = true
    var monitor: NWPathMonitor!
    
    func startMonitoring() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
        monitor = nil
    }
}
