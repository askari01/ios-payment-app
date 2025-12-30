//
//  SelectedPaymentMethodRepositoryImpl.swift
//  PaymentApp
//
//  Created by Farrukh Askari on 30/12/2025.
//

import Foundation

final class SelectedPaymentMethodRepositoryImpl: SelectedPaymentMethodRepository {

    private let api: APIClient
    private let credentialStore: CredentialStore

    init(api: APIClient, credentialStore: CredentialStore) {
        self.api = api
        self.credentialStore = credentialStore
    }

    func initiatePayment(
        paymentInitiationRequest: PaymentInitiationRequest,
        token: String,
    ) async throws -> String {

        let response: PaymentInitiationResponse = try await api.request(
            SelectedPaymentMethodEndpoints.initiatePayment(
                body: paymentInitiationRequest,
                token: token
            )
        )

        return response.url
    }
}
