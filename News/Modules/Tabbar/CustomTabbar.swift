//
//  CustomTabbar.swift
//  News
//
//  Created by Ahmed on 30/07/2023.
//

import UIKit

@IBDesignable
class CustomTabbar: UITabBar {
    override func layoutSubviews() {
        super.layoutSubviews()
        drawTabBar()
    }
    
    // MARK: - Drawing Tabbar
    private func drawTabBar() {
        let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first { $0.isKeyWindow } as? UIWindow
        let bottomPadding: CGFloat = (window?.safeAreaInsets.bottom) ?? 0.0
        let positionOnX: CGFloat = 20
        var positionOnY: CGFloat = 0
        if bottomPadding > 0 {
            positionOnY = 7
        }
        let width = self.bounds.width - positionOnX * 2
        let height = self.bounds.height - positionOnY * 2
        
        let roundLayer = CAShapeLayer()
        var bezierPath: UIBezierPath!
        if bottomPadding == 0 {
            bezierPath = UIBezierPath(
                roundedRect: CGRect(
                    x: positionOnX,
                    y: self.bounds.minY - positionOnY,
                    width: width,
                    height: height
                ),
                byRoundingCorners: [.topRight, .topLeft],
                cornerRadii: CGSize(width: 30, height: 30)
            )
        } else {
            bezierPath = UIBezierPath(
                roundedRect: CGRect(
                    x: positionOnX,
                    y: self.bounds.minY - positionOnY,
                    width: width,
                    height: height
                ),
                cornerRadius: 30
            )
        }
        
        roundLayer.path = bezierPath.cgPath
        roundLayer.strokeColor = UIColor.black.cgColor
        roundLayer.lineWidth = 1.0
        self.layer.insertSublayer(roundLayer, at: 0)
        
        self.itemWidth = width / 5
        self.itemPositioning = .centered
        
        roundLayer.fillColor = UIColor.white.cgColor
    }
}
