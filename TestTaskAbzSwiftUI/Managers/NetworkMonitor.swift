//
//  NetworkMonitor.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 21/02/2025.
//

import Foundation
import Network
import Combine

// MARK: - NetworkMonitorProtocol
protocol NetworkMonitorProtocol {
    var isConnected: Bool { get set }
    var isConnectedPublisher: AnyPublisher<Bool, Never> { get }
}

class NetworkMonitor: NetworkMonitorProtocol, ObservableObject {
    @Published var isConnected: Bool = true
   
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    var isConnectedPublisher: AnyPublisher<Bool, Never> {
        $isConnected.eraseToAnyPublisher()
    }
    
    // MARK: - Initialization
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
