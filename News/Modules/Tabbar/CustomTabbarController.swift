//
//  CustomTabbar.swift
//  News
//
//  Created by Ahmed on 30/07/2023.
//

import UIKit

class CustomTabbarController: UITabBarController {
    let customTabbar = CustomTabbar()
    // MARK: - Initializer(s)
    init() {
        super.init(nibName: nil, bundle: nil)
        object_setClass(self.tabBar, CustomTabbar.self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = getViewControllers()
    }
    
    /// Getting ViewControllers
    private func getViewControllers() -> [UIViewController] {
        [createTabbarItem(tabbarItem: .Home),
         createTabbarItem(tabbarItem: .Categories),
         createTabbarItem(tabbarItem: .Saved)]
    }
    
    // MARK: - Create tabbar item
    private func createTabbarItem(tabbarItem: TabbarItems) -> UIViewController {
        let vc = tabbarItem.getRelativeVC()
        vc.tabBarItem = UITabBarItem(
            title: tabbarItem.getRelativeTitle(),
            image: tabbarItem.getRelativeImage(isSelected: false)?.withRenderingMode(.alwaysOriginal),
            selectedImage: tabbarItem.getRelativeImage(isSelected: true)?.withRenderingMode(.alwaysOriginal))
        setTabbarItemViewAppearance(vc: vc)
        return vc
    }
    
    // MARK: - Tabbar item appearance
    private func setTabbarItemViewAppearance(vc: UIViewController) {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .clear
        tabBarAppearance.configureWithTransparentBackground()
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = getSelectedTabbarItemTextAttributes()
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = getNormalTabbarItemTextAttributes()
        tabBarAppearance.inlineLayoutAppearance.selected.titleTextAttributes = getSelectedTabbarItemTextAttributes()
        tabBarAppearance.inlineLayoutAppearance.normal.titleTextAttributes = getNormalTabbarItemTextAttributes()
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
    }
    
    /// Tabbar text normal attributes
    private func getNormalTabbarItemTextAttributes() -> [NSAttributedString.Key : Any] {
        return [
            .foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 11, weight: .regular)
        ]
    }
    
    /// Tabbar text selected attributes
    private func getSelectedTabbarItemTextAttributes() -> [NSAttributedString.Key : Any] {
        return [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 11, weight: .semibold)
        ]
    }
}
