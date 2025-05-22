//
//  EmptyStateView.swift
//  News
//
//  Created by Ahmed Abdo on 18/05/2025.
//

import UIKit

class EmptyStateView: UIView {
    // MARK: - Outlet(s)
    @IBOutlet weak var emptyStateImage: UIImageView!
    
    // MARK: - Initializer(s)
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibFromFile()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibFromFile()
    }
    
    // MARK: - Attaching empty state view to any superView
    func attach(
        to view: UIView,
        using imageName: String,
        isHidden: Bool = true
    ) {
        emptyStateImage.image = UIImage(named: imageName)
        self.isHidden = isHidden
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55),
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Passing in the image Name
    func setup(imageName: String) {
        emptyStateImage.image = UIImage(named: imageName)
    }
}
