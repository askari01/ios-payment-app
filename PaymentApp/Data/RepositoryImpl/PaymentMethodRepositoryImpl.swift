//
//  PaymentMethodRepositoryImpl.swift
//  PaymentApp
//
//  Created by Farrukh Askari on 30/12/2025.
//

import Foundation

final class PaymentMethodRepositoryImpl: PaymentMethodRepository {

    private let api: APIClient
    private let credentialStore: CredentialStore

    init(api: APIClient, credentialStore: CredentialStore) {
        self.api = api
        self.credentialStore = credentialStore
    }

    func fetchMethods(sessionId: String, token: String) async throws -> [PaymentMethod] {

        let response: PaymentMethodsResponse = try await api.request(
            PaymentMethodEndpoints.list(
                sessionId: sessionId,
                token: token
            )
        )

        return response.methods
    }
}
