//
//  Auth.swift
//  PaymentApp
//
//  Created by Farrukh Askari on 30/12/2025.
//

import SwiftUI

@Observable
final class AuthViewModel {

    private let repo: AuthRepository

    var token: String?
    var error: String?
    var isLoading = false

    init(repo: AuthRepository) {
        self.repo = repo
    }

    func authenticate() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await repo.authenticate()
            token = response.token
            print(response.token)
        } catch {
            self.error = error.localizedDescription
            print(error)
        }
    }
}
