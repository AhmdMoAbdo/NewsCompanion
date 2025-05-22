//
//  Observable.swift
//  News
//
//  Created by Ahmed Abdo on 14/05/2025.
//

import Foundation

class Observable<T> {
    /// Replace the closure with Observer word for readability
    typealias Observer = (T) -> Void
    
    /// The Value to be observed and will notify all observers in case any update happens to that value
    private var value: T? {
        didSet {
            notifyObservers()
        }
    }
    
    /// Observers array
    private var observers: [Observer] = []
    
    // MARK: - Initializer(s)
    init(_ value: T? = nil) {
        self.value = value
    }
    
    /// Setting a new value which in turn will notify all observers
    func onNext(_ value: T) {
        self.value = value
    }
    
    /// Register self as an observer to value updates
    func observe(_ observer: @escaping Observer) {
        observers.append(observer)
    }
    
    /// Notify all observers of value updates
    private func notifyObservers() {
        guard let value else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            observers.forEach { $0(value) }
        }
    }
}
