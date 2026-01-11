//
//  ContentView.swift
//  PaymentApp
//
//  Created by Farrukh Askari on 25/12/2025.
//

import SwiftUI
import WebKit
import Observation
import PaymentSDK

struct ContentView: View {

    @State private var showWebView = false
    @State private var page = WebPage()
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
                                          sessionId: cvm.sessionId!)
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
            await cvm.startCheckout()
            if let sessionId = cvm.sessionId {
                await pvm.load(sessionId: sessionId)
            }
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
    let client = PaymentClient(
        username: "ij@technologies.dk",
        password: "6#Nf2XE#wwAvAN4qL",
        baseURL: URL(string: "https://testgateway.altapaysecure.com/")!
    )
    
    let cvm = CheckoutViewModel(client: client)
    let pvm = PaymentMethodsViewModel(client: client)
    let svm = SelectedPaymentMethodViewModel(client: client)
    
    return ContentView(cvm: cvm, pvm: pvm, spvm: svm)
}
