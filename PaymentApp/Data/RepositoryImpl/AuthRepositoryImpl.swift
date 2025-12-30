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

    init(api: APIClient, credentialStore: CredentialStore) {
        self.api = api
        self.credentialStore = credentialStore
    }

    func authenticate() async throws -> AuthResponse {
        let authHeader = BasicAuth.header(
            username: credentialStore.username,
            password: credentialStore.password
        )

        let response: AuthResponse = try await api.request(
            AuthEndpoints.authenticate(
                authorization: authHeader
            )
        )
        return response
    }
}

