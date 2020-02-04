//
//  Extensions.swift
//  Engineering_AI_IOS
//
//  Created by Swaminath Kosetty on 04/02/20.
//  Copyright © 2020 Ojas. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    func showAlert(title: String) {
        let alert = UIAlertController.init(title: "", message: title, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    func setUpSpinner(style: UIActivityIndicatorView.Style) -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView()
        spinner.style = style
        spinner.color = .darkGray
        return spinner
    }
    func showSpinner(destination: Destination, activityIndicator: UIActivityIndicatorView) {
        let centerFrame = CGRect(x: self.view.center.x - 25, y: self.view.center.y, width: 50, height: 50)
        let bottomFrame = CGRect(x: self.view.center.x - 25, y: screenHeight - 65,  width: 50, height: 50)
        switch destination {
        case .bottom:
            activityIndicator.frame = bottomFrame
        case .center:
            activityIndicator.frame = centerFrame
        }
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
    }
    func hideSpinner(activityIndicator: UIActivityIndicatorView){
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
}
