//
//  MainRouterView.swift
//  AnyBuy
//
//  Created by User on 22/04/26.
//

import SwiftUI

struct MainRouterView: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        Group {
            if authVM.session == nil {
                LoginView()
            } else if let user = authVM.currentUser {
                if user.isAdmin {
                    AdminDashboardView()
                } else {
                    MainUserTabView()
                }
            } else {
                ProgressView("Chargement du profil...")
            }
        }
        .animation(.easeInOut, value: authVM.session)
    }
}
