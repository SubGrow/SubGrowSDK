//
//  FirstOfferViewController.swift
//  B2S
//
//  Created Egor Sakhabaev on 05.07.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Sakhabaev Egor @Banck
//  https://github.com/Banck/Swift-viper-template-for-xcode
//

import UIKit

class FirstOfferViewController: UIViewController {
    // MARK: - Properties
	var presenter: FirstOfferPresenterInterface?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundImageBlurView: UIVisualEffectView!

    @IBOutlet weak var closeButton: UIButton!
    //Top content
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var iconBlurView: UIVisualEffectView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    //Bottom content
    @IBOutlet weak var bottomDescriptionLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var footerTextView: UITextView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    // MARK: - Lifecycle -
	override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        presenter?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.viewDidAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.viewDidDisappear()
    }
}

// MARK: - UI Configuration
extension FirstOfferViewController {
    private func configureUI() {
        actionButton.layer.cornerRadius = 4
        footerTextView.linkTextAttributes = [.foregroundColor: UIColor.hexStringToUIColor(hex: "#FBA12B")]
    }
}

// MARK: - FirstOfferView
extension FirstOfferViewController: FirstOfferView {
    func display(image: ImageData?, title: TextData?, subtitle: TextData?, footer: String?, offer: TextData?, promotionButton: ButtonData, background: (image: ImageData?, color: String?)) {
        iconImageView.isHidden = image == nil
        if let imageData = image {
            displayImage(imageData, imageView: iconImageView, blurView: iconBlurView)
        }
        
        titleLabel.text = title?.text
        titleLabel.textColor = UIColor.hexStringToUIColor(hex: title?.color ?? "" )
        titleLabel.isHidden = title == nil
        
        subtitleLabel.text = subtitle?.text
        subtitleLabel.textColor = UIColor.hexStringToUIColor(hex: subtitle?.color ?? "" )
        subtitleLabel.isHidden = subtitle == nil
        
        bottomDescriptionLabel.text = offer?.text
        bottomDescriptionLabel.textColor = UIColor.hexStringToUIColor(hex: offer?.color ?? "" )
        bottomDescriptionLabel.isHidden = offer == nil

        actionButton.setTitle(promotionButton.text, for: .normal)
        actionButton.setTitleColor(UIColor.hexStringToUIColor(hex: promotionButton.textColor), for: .normal)
        actionButton.backgroundColor = UIColor.hexStringToUIColor(hex: promotionButton.backgroundColor)
        
        backgroundImageView.isHidden = background.image == nil
        if let imageData = background.image {
            displayImage(imageData, imageView: backgroundImageView, blurView: backgroundImageBlurView)
        }
        
        if let backgroundColor = background.color {
            backgroundView.backgroundColor = UIColor.hexStringToUIColor(hex: backgroundColor)
        }
        
        footerTextView.attributedText = footer?.htmlToString()
    }
    
    func startLoading() {
        UIView.animate(withDuration: 0.25) {
            self.loaderView.alpha = 1.0
            self.activityIndicatorView.startAnimating()
        }
    }
    
    func stopLoading() {
        UIView.animate(withDuration: 0.25) {
            self.loaderView.alpha = 0.0
            self.activityIndicatorView.stopAnimating()
        }
    }
}

// MARK: - Actions
extension FirstOfferViewController {
    @IBAction
    func purchaseButtonDidSelect() {
        presenter?.didSelectAction()
    }
    
    @IBAction
    func closeButtonDidSelect() {
        presenter?.didSelectClose()
    }
}

// MARK: - Private methods
extension FirstOfferViewController {
    private func displayImage(_ data: ImageData, imageView: UIImageView, blurView: UIVisualEffectView) {
        if let imageData = data.data, let image = UIImage(data: imageData) {
            imageView.image = image
            blurView.alpha = 0
            return
        }
        
        let placeholderImage = UIImage(data: Data(base64Encoded: data.base64) ?? Data())
        imageView.image = placeholderImage
        
        guard let url = URL(string: data.url) else { return }

        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                imageView.image = image ?? placeholderImage
                if image != nil {
                    UIView.animate(withDuration: 0.25) {
                        blurView.alpha = 0.0
                    }
                }
            }
        }
    }
}
