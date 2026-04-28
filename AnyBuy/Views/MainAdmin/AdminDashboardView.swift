//
//  AdminDashboardView.swift
//  AnyBuy
//
//  Created by User on 22/04/26.
//

import SwiftUI
import Charts

struct AdminDashboardView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Performance") {
                    Chart {
                        BarMark(x: .value("Mois", "Jan"), y: .value("Ventes", 1200))
                        BarMark(x: .value("Mois", "Fev"), y: .value("Ventes", 1900))
                        BarMark(x: .value("Mois", "Mar"), y: .value("Ventes", 1500))
                    }
                    .frame(height: 150)
                }
                
                NavigationLink("Valider les demandes", destination: Text("Liste des requêtes SQL ici"))
                NavigationLink("Utilisateurs", destination: Text("Gestion users"))
            }
            .navigationTitle("Dashboard Admin")
        }
    }
}
