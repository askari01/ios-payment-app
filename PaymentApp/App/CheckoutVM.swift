//
//  CheckoutVM.swift
//  PaymentApp
//
//  Created by Farrukh Askari on 30/12/2025.
//

import SwiftUI

@Observable
final class CheckoutViewModel {

    private let checkoutRepo: CheckoutRepository

    var sessionId: String?
    var isLoading = false
    var error: String?

    init(checkoutRepo: CheckoutRepository) {
        self.checkoutRepo = checkoutRepo
    }

    func startCheckout(token: String) async {
        isLoading = true
        defer { isLoading = false }

        do {
            let request = CheckoutRequest(
                order: Order(
                    orderId: "RonnieCheckoutAPITest",
                    amount: .init(value: 2.0, currency: "DKK"),
                    orderLines: [
                        .init(itemId: "123981239", description: "Chaos Emerald", quantity: 1, unitPrice: 1),
                        .init(itemId: "123981240", description: "Delivery", quantity: 1, unitPrice: 1)
                    ],
                    customer: Customer(
                        firstName: "John",
                        lastName: "Doe",
                        email: "test@example.com",
                        billingAddress: .init(
                            street: "Nygaardsvej 42",
                            city: "Copenhagen",
                            country: "DK",
                            zipCode: "1040"
                        ),
                        shippingAddress: .init(
                            street: "Nygaardsvej 42",
                            city: "Copenhagen",
                            country: "DK",
                            zipCode: "1040"
                        )
                    ),
                    transactionInfo: [
                        "additionalProp1": "Additional Payment information test 1",
                        "additionalProp2": "Additional Payment information test 2",
                        "additionalProp3": "Additional Payment information test 3"
                    ]
                ),
                //                callbacks: Callbacks(
                //                    success: .init(type: "URL", value: "https://example.com"),
                //                    failure: .init(type: "URL", value: "https://example.com/fail"),
                //                    redirect: "https://example.com/redirect",
                //                    notification: "https://example.com/notification",
                //                    bodyFormat: nil
                //                ),
                configuration: Configuration(
                    paymentType: "PAYMENT",
                    paymentDisplayType: "REDIRECT",
                    bodyFormat: "JSON",
                    autoCapture: false,
                    country: "DK",
                    language: "da"
                )
            )

            let response = try await checkoutRepo.createSession(
                request: request,
                token: token
            )
            print(response.sessionId)
            sessionId = response.sessionId

        } catch {
            self.error = error.localizedDescription
            print(error)
        }
    }
}
