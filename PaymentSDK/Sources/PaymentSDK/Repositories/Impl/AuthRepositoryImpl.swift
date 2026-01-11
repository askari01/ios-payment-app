//
//  AuthRepository.swift
//  PaymentApp
//
//  Created by Farrukh Askari on 30/12/2025.
//

import Foundation

final class AuthRepositoryImpl: AuthRepository {

    private let api: APIClient
    private let credentialStore: CredentialStore
    private let baseURL: URL

    init(api: APIClient, credentialStore: CredentialStore, baseURL: URL) {
        self.api = api
        self.credentialStore = credentialStore
        self.baseURL = baseURL
    }

    func authenticate() async throws -> AuthResponse {
        let authHeader = BasicAuth.header(
            username: credentialStore.username,
            password: credentialStore.password
        )

        let response: AuthResponse = try await api.request(
            AuthEndpoints.authenticate(
                baseURL: baseURL,
                authorization: authHeader
            )
        )
        return response
    }
}
