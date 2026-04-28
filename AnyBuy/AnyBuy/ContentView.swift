import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ProductViewModel()
    @State private var isAdminMode = false // Simule le type d'utilisateur connecté

    var body: some View {
        Group {
            if isAdminMode {
              //  AdminMainView(viewModel: viewModel)
            } else {
              //  MainTabView(viewModel: viewModel) // L'interface client classique
            }
        }
    }
}
