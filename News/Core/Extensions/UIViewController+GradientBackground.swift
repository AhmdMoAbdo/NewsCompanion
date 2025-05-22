//
//  UIViewController+GradientBackground.swift
//  News
//
//  Created by Ahmed on 30/07/2023.
//

import UIKit

extension UIViewController {
    func addGradientBackground() {
        guard !(view.layer.sublayers?.contains(where: { $0 is CAGradientLayer }) ?? false) else { return }
        let gradientLayer = getGradientBackground(
            colorTop: UIColor(named: "customGrey")?.cgColor ?? UIColor.lightGray.cgColor,
            colorBottom: UIColor.white.cgColor
        )
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func getGradientBackground(colorTop: CGColor, colorBottom: CGColor) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        return gradientLayer
    }
}
