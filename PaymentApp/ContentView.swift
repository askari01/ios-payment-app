//
//  ContentView.swift
//  PaymentApp
//
//  Created by Farrukh Askari on 25/12/2025.
//

import SwiftUI
import WebKit

struct ContentView: View {

    @State private var showWebView = false
    @State private var page = WebPage()
    @State var avm: AuthViewModel
    @State var cvm: CheckoutViewModel
    @State var pvm: PaymentMethodsViewModel
    @State var spvm: SelectedPaymentMethodViewModel

    var body: some View {
        List(pvm.methods) { method in
            Button {
                print(method)
                Task {
                    await spvm
                        .onMethodSelected(method: method,
                                          sessionId: cvm.sessionId!,
                                          token: avm.token!)
                }
            } label: {
                row(method)
            }
            .buttonStyle(.plain)
        }
        .sheet(
            isPresented: Binding(
                get: { spvm.redirectURL != nil },
                set: { presented in
                    if !presented { spvm.redirectURL = nil }
                }
            ),
            content: {
                if let url = spvm.redirectURL {
                    WebView(page).onAppear {
                        page.load(url)
                    }
                } else {
                    // Fallback empty view
                    EmptyView()
                }
            }
        )
        .task {
            await avm.authenticate()
            await cvm.startCheckout(token: avm.token!)
            await pvm.load(sessionId: cvm.sessionId!, token: avm.token!)
        }
        .padding()
    }
}

@ViewBuilder
private func row(_ method: PaymentMethod) -> some View {
    HStack(spacing: 12) {

        if let logo = method.logoUrl,
           let url = URL(string: logo),
           !logo.contains("null") {
            AsyncImage(url: url) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 40, height: 40)
        }

        VStack(alignment: .leading) {
            Text(method.name)
                .font(.headline)

            Text(method.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }

        Spacer()

        Text(method.type)
            .font(.caption)
    }
}


#Preview {
    struct PreviewCredentialStore: CredentialStore {
        var username: String { "ij@technologies.dk" }
        var password: String { "6#Nf2XE#wwAvAN4qL" }
    }

    let client = URLSessionAPIClient()
    let credentialStore = PreviewCredentialStore()

    let authRepo = AuthRepositoryImpl(api: client, credentialStore: credentialStore)
    let checkoutRepo = CheckoutRepositoryImpl(api: client, credentialStore: credentialStore)
    let paymentMethodRepo = PaymentMethodRepositoryImpl(api: client, credentialStore: credentialStore)
    let selectedPaymentMethodRepo = SelectedPaymentMethodRepositoryImpl(api: client, credentialStore: credentialStore)

    let avm = AuthViewModel(repo: authRepo)
    let cvm = CheckoutViewModel(checkoutRepo: checkoutRepo)
    let pvm = PaymentMethodsViewModel(repo: paymentMethodRepo)
    let svm = SelectedPaymentMethodViewModel(repo: selectedPaymentMethodRepo)

    return ContentView(avm: avm, cvm: cvm, pvm: pvm, spvm: svm)
}
