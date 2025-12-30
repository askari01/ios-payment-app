//
//  PaymentMethodsVM.swift
//  PaymentApp
//
//  Created by Farrukh Askari on 30/12/2025.
//

import SwiftUI

@Observable
final class PaymentMethodsViewModel {

    private let repo: PaymentMethodRepository

    var methods: [PaymentMethod] = []
    var isLoading = false
    var error: String?

    init(repo: PaymentMethodRepository) {
        self.repo = repo
    }

    func load(sessionId: String, token: String) async {
        isLoading = true
        defer { isLoading = false }

        do {
            methods = try await repo.fetchMethods(sessionId: sessionId, token: token)
            print(methods)
        } catch {
            self.error = error.localizedDescription
        }
    }
}
