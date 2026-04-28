//
//  AuthManager.swift
//  AnyBuy
//
//  Created by User on 17/04/26.
//

import SwiftUI
import Combine

class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: String? = nil
    @Published var isAdmin = false
    
    func login(email: String, isAdminAccount: Bool = false) {
        // Simulation de connexion
        self.currentUser = email
        self.isAdmin = isAdminAccount
        withAnimation {
            self.isAuthenticated = true
        }
    }
    
    func logout() {
        self.isAuthenticated = false
        self.currentUser = nil
        self.isAdmin = false
    }
}
