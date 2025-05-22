//
//  ReachabilityManager.swift
//  News
//
//  Created by Ahmed Abdo on 14/05/2025.
//

import Foundation
import Reachability

class ReachabilityManager {
    static var shared = ReachabilityManager()
    private var reachability: Reachability?
    var isConnected: Bool = true {
        didSet {
            notifyObservers()
        }
    }
    private var observers: [NetworkStateObservable] = []
    
    // MARK: - Initializer(s)
    private init() {
        startConnectionMonitoring()
    }
    
    // MARK: - Starting connection monitoring
    private func startConnectionMonitoring() {
        let reachability = try? Reachability()
        self.reachability = reachability
        reachability?.whenReachable = { [weak self] connection in
            guard let self else { return }
            isConnected = true
        }
        reachability?.whenUnreachable = { [weak self] _ in
            guard let self else { return }
            isConnected = false
        }
        try? reachability?.startNotifier()
    }
    
    // MARK: - Observation Handling
    /// Observe network state updates
    func observeNetworkState(observer: NetworkStateObservable) {
        observers.append(observer)
    }
    
    /// Stop observing network state
    func stopObservingNetworkState(observer: NetworkStateObservable) {
        observers.removeAll { $0 === observer }
    }
    
    /// Notify all observers of a netowrk update
    func notifyObservers() {
        observers.forEach { $0.didUpdateNetworkState(isConnected) }
    }
    
    // MARK: - Deinitializer(s)
    deinit {
        reachability?.stopNotifier()
    }
}

// MARK: - Observation
protocol NetworkStateObservable: AnyObject {
    func didUpdateNetworkState(_ isConnected: Bool)
}
