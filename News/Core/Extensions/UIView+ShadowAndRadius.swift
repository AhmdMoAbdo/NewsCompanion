//
//  UIView+ShadowAndRadius.swift
//  News
//
//  Created by Ahmed on 30/07/2023.
//

import UIKit

extension UIView {
    func giveShadowAndRadius(scale: Bool = true, shadowRadius:Int, cornerRadius:Int) {
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = .zero
        layer.shadowRadius = CGFloat(integerLiteral: shadowRadius)
        layer.shouldRasterize = true
        layer.cornerRadius = CGFloat(integerLiteral: cornerRadius)
        layer.masksToBounds = false
    }
}
