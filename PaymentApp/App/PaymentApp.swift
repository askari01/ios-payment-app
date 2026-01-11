//
//  PaymentApp.swift
//
//  Created by Farrukh Askari on 25/12/2025.
//

import SwiftUI
import PaymentSDK

@main
struct PaymentApp: App {

    private let client: PaymentClient
    private var cvm: CheckoutViewModel
    private var pvm: PaymentMethodsViewModel
    private var svm: SelectedPaymentMethodViewModel

    init() {
        self.client = PaymentClient(
            username: "ij@technologies.dk",
            password: "6#Nf2XE#wwAvAN4qL",
            baseURL: URL(string: "https://testgateway.altapaysecure.com/")!
        )

        cvm = CheckoutViewModel(client: client)
        pvm = PaymentMethodsViewModel(client: client)
        svm = SelectedPaymentMethodViewModel(client: client)
    }

    var body: some Scene {
        WindowGroup {
            ContentView(cvm: cvm, pvm: pvm, spvm: svm)
        }
    }
}
