//
//  NetworkMonitor.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 21/02/2025.
//

import Foundation
import Network
import Combine

protocol NetworkMonitorProtocol {
    var isConnected: Bool { get set }
    var isConnectedPublisher: AnyPublisher<Bool, Never> { get }
}

class NetworkMonitor: NetworkMonitorProtocol, ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    @Published var isConnected: Bool = true
    var isConnectedPublisher: AnyPublisher<Bool, Never> {
            $isConnected.eraseToAnyPublisher()
        }
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
