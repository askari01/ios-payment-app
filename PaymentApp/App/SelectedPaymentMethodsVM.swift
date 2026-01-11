//
//  SelectedPaymentMethodsVM.swift
//  PaymentApp
//
//  Created by Farrukh Askari on 30/12/2025.
//

import SwiftUI
import PaymentSDK

@Observable
final class SelectedPaymentMethodViewModel {
    private let client: PaymentClient
    var redirectURL: URL?

    init(client: PaymentClient) {
        self.client = client
    }

    func onMethodSelected(
        method: PaymentMethod,
        sessionId: String
    ) async {
        guard !sessionId.isEmpty else {
            print("Payment initiation failed: Missing session ID")
            return
        }
        
        do {
            let url = try await client.initiatePayment(methodId: method.id, sessionId: sessionId)
            redirectURL = url
        } catch {
            print("Payment initiation failed:", error)
        }
    }
}
