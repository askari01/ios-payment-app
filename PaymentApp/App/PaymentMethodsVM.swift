//
//  PaymentMethodsVM.swift
//  PaymentApp
//
//  Created by Farrukh Askari on 30/12/2025.
//

import SwiftUI
import PaymentSDK

@Observable
final class PaymentMethodsViewModel {

    private let client: PaymentClient

    var methods: [PaymentMethod] = []
    var isLoading = false
    var error: String?

    init(client: PaymentClient) {
        self.client = client
    }

    func load(sessionId: String) async {
        isLoading = true
        defer { isLoading = false }

        do {
            methods = try await client.getPaymentMethods(sessionId: sessionId)
            print(methods)
        } catch {
            self.error = error.localizedDescription
        }
    }
}
