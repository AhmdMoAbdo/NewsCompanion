//
//  ArticleTableViewCell.swift
//  News
//
//  Created by Ahmed on 30/07/2023.
//

import UIKit
import Kingfisher

class ArticleTableViewCell: UITableViewCell {
    // MARK: - Outlet(s)
    @IBOutlet weak var favButtonContainer: UIView!
    @IBOutlet weak var favButton: UIImageView!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var articleDescription: UILabel!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleSource: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    
    // MARK: - Properties
    var favButtonAction:()->() = {}
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .clear
        dataContainerView.giveShadowAndRadius(shadowRadius: 5, cornerRadius: 20)
        favButtonContainer.giveShadowAndRadius(shadowRadius: 5, cornerRadius: 10)
        favButton.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(self.handleTap(_:))
            )
        )
    }
    
    // MARK: - Fav button action
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        favButtonAction()
    }
    
    // MARK: - Setting up cell
    func setupCell(
        article: Article,
        isFavorite: Bool,
        favButtonAction: @escaping () -> Void
    ) {
        KF.url(URL(string: article.urlToImage ?? "")).onFailure { [weak self] _ in
            self?.articleImage.image = UIImage(named: Constants.Images.imageNotAvailable)
        }.set(to: articleImage)
        self.favButtonAction = favButtonAction
        updateFavButtonImage(isFavorite: isFavorite)
        articleTitle.text = article.title
        articleSource.text = article.source?.name
        articleDescription.text = article.articleDescription
    }
    
    // MARK: - Update fav button image
    func updateFavButtonImage(isFavorite: Bool) {
        favButton.image = UIImage(systemName: isFavorite ? Constants.Images.bookMarkFilled : Constants.Images.bookMark)
    }
}
