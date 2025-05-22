//
//  DetailsViewController.swift
//  News
//
//  Created by Ahmed on 30/07/2023.
//

import UIKit
import Kingfisher

class DetailsViewController: UIViewController {
    // MARK: - Outlet(s)
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var bookmarkImage: UIImageView!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleSource: UILabel!
    @IBOutlet weak var articleDate: UILabel!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var descriptionWordItself: UILabel!
    @IBOutlet weak var articleDescription: UILabel!
    
    // MARK: - Properties
    var preMadeAlerts = PreMadeAlerts()
    var viewModel: DetailsViewModel
    
    // MARK: - Initializer(s)
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setArticleDetails()
    }
    
    func setArticleDetails() {
        articleTitle.text = viewModel.article.title
        articleSource.text = viewModel.article.source?.name
        setupBookMarkImage()
        setupArticleImage()
        setupArticleDescription()
        setPublishDate()
    }
    
    /// BookMark Image
    private func setupBookMarkImage() {
        bookmarkImage.image = UIImage(systemName: viewModel.article.type.contains(Constants.DB.favorite) ? Constants.Images.bookMarkFilled : Constants.Images.bookMark)
    }
    
    /// Article Image
    private func setupArticleImage() {
        articleImage.giveShadowAndRadius(shadowRadius: 5, cornerRadius: 20)
        articleImage.layer.masksToBounds = true
        KF.url(
            URL(
                string: viewModel.article.urlToImage ?? ""
            )
        )
        .onFailure { [weak self] _ in
            self?.articleImage.image = UIImage(named: "notAvailable")
        }
        .set(to: articleImage)
    }
    
    /// Article Description
    private func setupArticleDescription() {
        if viewModel.article.articleDescription == nil {
            descriptionWordItself.text = ""
        } else {
            articleDescription.text = viewModel.article.articleDescription
        }
    }
    
    /// Article Publish Date
    func setPublishDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: viewModel.article.publishedAt!)!
        articleDate.text = date.formatted(date: .long, time: .shortened)
    }
    
    // MARK: - Back Button action
    @IBAction func backButtonPressed(_ sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Read full article action
    @IBAction func readFullArticleButtonPressed(_ sender: Any) {
        if ReachabilityManager.shared.isConnected {
            viewModel.presentFullArticleDetails()
        } else {
            self.present(
                preMadeAlerts.getOkStyleSheetAlert(
                    message: Constants.Alerts.connectToReadArticle
                ),
                animated: true
            )
        }
    }
    
    // MARK: - Save button action
    @IBAction func saveButtonClicked(_ sender: UITapGestureRecognizer) {
        if viewModel.article.type.contains(Constants.DB.favorite) {
            present(
                preMadeAlerts.getDeleteConfirmationAlert { [weak self] in
                    guard let self else { return }
                    viewModel.deleteArticleFromSaved()
                    setupBookMarkImage()
                },
                animated: true
            )
            setupBookMarkImage()
        } else {
            viewModel.addArticleToFav()
            present(
                preMadeAlerts.getOkStyleSheetAlert(),
                animated: true
            )
        }
    }
}
