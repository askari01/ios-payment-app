//
//  CheckoutRepository.swift
//  PaymentApp
//
//  Created by Farrukh Askari on 30/12/2025.
//

import Foundation

final class CheckoutRepositoryImpl: CheckoutRepository {

    private let api: APIClient
    private let baseURL: URL

    init(api: APIClient, baseURL: URL) {
        self.api = api
        self.baseURL = baseURL
    }

    func createSession(
        request: CheckoutRequest,
        token: String
    ) async throws -> CheckoutSessionResponse {

        try await api.request(
            CheckoutEndpoints.createSession(
                baseURL: baseURL,
                body: request,
                authorization: "Bearer \(token)"
            )
        )
    }
}
