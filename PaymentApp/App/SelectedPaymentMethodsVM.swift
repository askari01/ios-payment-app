//
//  SelectedPaymentMethodsVM.swift
//  PaymentApp
//
//  Created by Farrukh Askari on 30/12/2025.
//

import SwiftUI

@Observable
final class SelectedPaymentMethodViewModel {
    private let repo: SelectedPaymentMethodRepository
    var redirectURL: URL?

    init(repo: SelectedPaymentMethodRepository) {
        self.repo = repo
    }

    func onMethodSelected(
        method: PaymentMethod,
        sessionId: String,
        token: String
    ) async {
        let paymentInitiationRequest = PaymentInitiationRequest(
            paymentMethodId: method.id,
            sessionId: sessionId
        )
        do {
            let response = try await repo.initiatePayment(
                paymentInitiationRequest: paymentInitiationRequest,
                token: token,
            )
            if let url = URL(string: response) {
                redirectURL = url
            }
        } catch {
            print("Payment initiation failed:", error)
        }
    }
}
