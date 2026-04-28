import SwiftUI

struct MyPurchasesView: View {
    var body: some View {
        List {
            Section("En cours") {
                Text("Aucun achat en cours")
                    .foregroundColor(.secondary)
            }
            Section("Historique") {
                // Ici on bouclera sur une table 'orders' plus tard
            }
        }
        .navigationTitle("Mes Achats")
    }
}
