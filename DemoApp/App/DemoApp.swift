//
//  DemoApp.swift
//  DemoApp
//
//  Created by Farrukh Askari on 30/12/2025.
//

import SwiftUI
import AltaPaySDK

@main
struct DemoApp: App {
    
    init() {
        // Initialize AltaPay SDK
        do {
            try AltaPaySDK.initialize(
                baseURL: "https://testgateway.altapaysecure.com/",
                username: "xxxxxxxxxxxxxx", // Replace with your credentials
                password: "xxxxxxxxxxxxxx"  // Replace with your credentials
            )
            print("AltaPay SDK initialized successfully")
        } catch {
            print("Failed to initialize AltaPay SDK: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
