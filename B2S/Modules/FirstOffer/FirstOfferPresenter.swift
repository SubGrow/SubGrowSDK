//
//  FirstOfferPresenter.swift
//  B2S
//
//  Created Egor Sakhabaev on 05.07.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Sakhabaev Egor @Banck
//  https://github.com/Banck/Swift-viper-template-for-xcode
//

import UIKit
import StoreKit

final class FirstOfferPresenter {
    
    // MARK: - Properties
    weak private var view: FirstOfferView?
    var interactor: FirstOfferInteractorInput?
    private let router: FirstOfferWireframeInterface
    private let offer: Offer
    
    // MARK: - Initialization and deinitialization
    init(interface: FirstOfferView,
         interactor: FirstOfferInteractorInput?,
         router: FirstOfferWireframeInterface,
         offer: Offer) {
        self.view = interface
        self.interactor = interactor
        self.router = router
        self.offer = offer
    }
}

// MARK: - FirstOfferPresenterInterface
extension FirstOfferPresenter: FirstOfferPresenterInterface {
    func didSelectAction() {
        B2S.shared.delegate?.b2sPromotionOfferWillPurchase?(productId: offer.productId, offerId: offer.offerId)
        view?.startLoading()
        interactor?.purchasePromotionOffer(productId: offer.productId, offerId: offer.offerId)
    }

    func didSelectClose() {
        router.navigate(to: .dismiss)
    }
    
    // MARK: - Lifecycle -
    func viewDidLoad() {
        view?.display(image: offer.screenData.image,
                      title: offer.screenData.title,
                      subtitle: offer.screenData.subtitle,
                      offer: offer.screenData.offer,
                      promotionButton: offer.screenData.promotionButton,
                      background: (image: offer.screenData.backgroundImage, color: offer.screenData.backgroundColor))
        
        if offer.screenData.rulesURL != nil || offer.screenData.privacyURL != nil {
            var termsAndPrivacyText: String = "<style> p {text-align: center;}</style><body><p>{rulesURL} and {privacyURL}</p></body>"
            if let rulesURL = offer.screenData.rulesURL {
                termsAndPrivacyText = termsAndPrivacyText.replacingOccurrences(of: "{rulesURL}", with: "<a href=\"\(rulesURL)\">Terms of Service</a>")
            } else {
                termsAndPrivacyText = termsAndPrivacyText.replacingOccurrences(of: "{rulesURL} and ", with: "")
            }
            if let privacyURL = offer.screenData.privacyURL {
                termsAndPrivacyText = termsAndPrivacyText.replacingOccurrences(of: "{privacyURL}", with: "<a href=\"\(privacyURL)\">Privacy Policy</a>")
            } else {
                termsAndPrivacyText = termsAndPrivacyText.replacingOccurrences(of: " and {privacyURL}", with: "")
            }
            let termsColor = UIColor.hexStringToUIColor(hex: offer.screenData.subtitle.color)
            view?.display(termsAndPrivacyText: termsAndPrivacyText.htmlToString(color: termsColor))
        }
    }
}

// MARK: - FirstOfferInteractorOutput
extension FirstOfferPresenter: FirstOfferInteractorOutput {
    func purchasedPromotionOffer(with transaction: SKPaymentTransaction, offerData: (productId: String, offerId: String)) {
        B2S.shared.delegate?.b2sPromotionOfferDidPurchase?(productId: offerData.productId, offerId: offerData.offerId, transaction: transaction)
    }
    
    func purchasedPromotionOffer(with error: Error, offerData: (productId: String, offerId: String)) {
        let errorCode = (error as? SKError)?.code ?? .unknown
        B2S.shared.delegate?.b2sPromotionOfferDidFailPurchase?(productId: offerData.productId, offerId: offerData.offerId, errorCode: errorCode)
    }
    
    func fetchedFully() {
        view?.stopLoading()
    }
}
