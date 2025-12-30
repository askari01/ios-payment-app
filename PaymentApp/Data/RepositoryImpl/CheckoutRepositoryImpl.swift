//
//  CheckoutRepository.swift
//  PaymentApp
//
//  Created by Farrukh Askari on 30/12/2025.
//

import Foundation

final class CheckoutRepositoryImpl: CheckoutRepository {

    private let api: APIClient
    private let credentialStore: CredentialStore

    init(api: APIClient, credentialStore: CredentialStore) {
        self.api = api
        self.credentialStore = credentialStore
    }

    func createSession(
        request: CheckoutRequest,
        token: String
    ) async throws -> CheckoutSessionResponse {

        try await api.request(
            CheckoutEndpoints.createSession(
                body: request,
                authorization: "Bearer \(token)"
            )
        )
    }
}
