//
//  PaymentApp.swift
//
//  Created by Farrukh Askari on 25/12/2025.
//

import SwiftUI

@main
struct PaymentApp: App {

    // Provide a concrete runtime credential store. Replace with secure storage as needed.
    struct AppCredentialStore: CredentialStore {
        var username: String { "ij@technologies.dk" }
        var password: String { "6#Nf2XE#wwAvAN4qL" }
        var cookie: String { "" }
    }

    private let client: APIClient
    private let arepo: AuthRepository
    private var crepo: CheckoutRepository
    private var prepo: PaymentMethodRepository
    private var srepo: SelectedPaymentMethodRepository

    private var avm: AuthViewModel
    private var cvm: CheckoutViewModel
    private var pvm: PaymentMethodsViewModel
    private var svm: SelectedPaymentMethodViewModel

    init() {
        let client = URLSessionAPIClient()
        let arepo = AuthRepositoryImpl(api: client,
                                       credentialStore: AppCredentialStore())
        let crepo = CheckoutRepositoryImpl(
            api: client,
            credentialStore: AppCredentialStore()
        )
        let prepo = PaymentMethodRepositoryImpl(api: client,
                                                 credentialStore: AppCredentialStore())
        let srepo = SelectedPaymentMethodRepositoryImpl(
            api: client,
            credentialStore: AppCredentialStore()
        )

        self.client = client
        self.arepo = arepo
        self.crepo = crepo
        self.prepo = prepo
        self.srepo = srepo

        avm = AuthViewModel(repo: arepo)
        cvm = CheckoutViewModel(checkoutRepo: crepo)
        pvm = PaymentMethodsViewModel(repo: prepo)
        svm = SelectedPaymentMethodViewModel(repo: srepo)
    }

    var body: some Scene {
        WindowGroup {
            ContentView(avm: avm, cvm: cvm, pvm: pvm, spvm: svm)
        }
    }
}
