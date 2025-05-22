//
//  PreMadeAlerts.swift
//  News
//
//  Created by Ahmed on 01/08/2023.
//

import UIKit

class PreMadeAlerts{
    // MARK: - Informative action sheet
    func getOkStyleSheetAlert(
        message: String = Constants.Alerts.addedMessage,
        action: @escaping () -> Void = {}
    ) -> UIAlertController {
        let alert = UIAlertController(
            title: Constants.Alerts.warning,
            message: message,
            preferredStyle: .actionSheet
        )
        let okAction = UIAlertAction(
            title: Constants.Alerts.okAction ,
            style: .default
        ) { _ in
            action()
        }
        alert.addAction(okAction)
        return alert
    }
    
    // MARK: - Delete article confirmation alert
    func getDeleteConfirmationAlert(
        deleteHandler: @escaping () -> Void
    ) -> UIAlertController {
        let alert = UIAlertController(
            title: Constants.Alerts.warning,
            message: Constants.Alerts.deleteMessage,
            preferredStyle: .alert
        )
        let deleteAction = UIAlertAction(
            title: Constants.Alerts.deleteAction ,
            style: .destructive
        ) { _ in
            deleteHandler()
        }
        let CancelAction = UIAlertAction(
            title: Constants.Alerts.cancelAction ,
            style: .cancel
        )
        alert.addAction(deleteAction)
        alert.addAction(CancelAction)
        return alert
    }
}
