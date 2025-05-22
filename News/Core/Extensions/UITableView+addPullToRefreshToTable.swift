//
//  UITableView+addPullToRefreshToTable.swift
//  News
//
//  Created by Ahmed Abdo on 22/05/2025.
//

import UIKit

extension UITableView {
    func addSwipeToRefresh(using action: @escaping () -> Void) -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addAction(
            UIAction { _ in
                action()
                refreshControl.endRefreshing()
            },
            for: .valueChanged
        )
        self.refreshControl = refreshControl
        return refreshControl
    }
}
