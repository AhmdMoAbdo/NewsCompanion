//
//  TabbarScreenHeader.swift
//  News
//
//  Created by Ahmed Abdo on 18/05/2025.
//

import UIKit
import Lottie

class TabbarScreenHeader: UIView {
    // MARK: - Outlet(s)
    @IBOutlet weak var lottieAnimationView: LottieAnimationView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var animationToTextConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    private var configurations: TabbarHeaderViewConfigurations?
    private var currentLottieFrameIndex = 0
    private weak var containerVC: UIViewController?
    
    // MARK: - Initializer(s)
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibFromFile()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibFromFile()
    }
    
    // MARK: - Setting up view
    func setupHeader(
        configurations: TabbarHeaderViewConfigurations,
        containerVC: UIViewController
    ) {
        self.configurations = configurations
        self.containerVC = containerVC
        animationToTextConstraint.constant = configurations.animationToTextSpacing
        titleLabel.text = configurations.title
        lottieAnimationView.animation = LottieAnimation.named(configurations.animationName)
        layoutIfNeeded()
    }
    
    // MARK: - Playing lottie animation
    func playLottieAnimation() {
        guard let configurations else { return }
        if configurations.allowSegmentedAnimation {
            let endFrameIndex = currentLottieFrameIndex == configurations.lottieFramesArr.count - 1 ? 0 : currentLottieFrameIndex + 1
            lottieAnimationView.play(
                fromFrame: AnimationFrameTime(configurations.lottieFramesArr[currentLottieFrameIndex]),
                toFrame: AnimationFrameTime(configurations.lottieFramesArr[endFrameIndex]),
                loopMode: .playOnce
            )
            currentLottieFrameIndex = endFrameIndex
        } else {
            lottieAnimationView.play()
        }
    }
    
    // MARK: - Search Button
    @IBAction func searchButtonClicked(_ sender: UITapGestureRecognizer) {
        if ReachabilityManager.shared.isConnected {
            let searchVC = SearchRouter.createModule()
            containerVC?.navigationController?.pushViewController(searchVC, animated: true)
        } else {
            containerVC?.present(
                PreMadeAlerts().getOkStyleSheetAlert(
                    message: Constants.Alerts.searchError
                ),
                animated: true
            )
        }
    }
}
