import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = ProductViewModel()
    @State private var searchText = ""
    @State private var selectedCategory = "Tous"
    @State private var showFilterSheet = false
    
    // États pour les filtres avancés
    @State private var guestCount = 1
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(86400)
    
    let categories = ["Tous", "Mode", "High-Tech", "Maison", "Loisirs"]
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // --- 1. BARRE DE RECHERCHE + BOUTON FILTRE ---
                        HStack(spacing: 12) {
                            searchBar // La barre prend le maximum d'espace
                            
                            Button(action: { showFilterSheet.toggle() }) {
                                Image(systemName: "slider.horizontal.3")
                                    .font(.system(size: 18, weight: .medium))
                                    .padding(12)
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundColor(.blue)
                                    .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                        
                        // 2. Sélecteur de catégories
                        categoryPicker
                        
                        // 3. Grille de produits
                        if viewModel.products.isEmpty {
                            emptyState
                        } else {
                            productGrid
                        }
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("AnyBuy")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddProductView()) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .symbolRenderingMode(.hierarchical)
                    }
                }
            }
            .sheet(isPresented: $showFilterSheet) {
                filterSheetContent
            }
            .onAppear {
                Task { await viewModel.fetchProducts() }
            }
            .refreshable {
                await viewModel.fetchProducts()
            }
        }
    }
    
    // MARK: - Composants UI
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Rechercher...", text: $searchText)
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.03), radius: 5, x: 0, y: 2)
    }
    
    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { cat in
                    Button {
                        selectedCategory = cat
                    } label: {
                        Text(cat)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(selectedCategory == cat ? Color.blue : Color(.systemBackground))
                            .foregroundColor(selectedCategory == cat ? .white : .primary)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                            )
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var productGrid: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(viewModel.products.filter { product in
                // Filtre par texte (Titre ou Description)
                let matchSearch = searchText.isEmpty ||
                                  product.title.localizedCaseInsensitiveContains(searchText) ||
                                  product.description.localizedCaseInsensitiveContains(searchText)
                
                // Filtre par Catégorie
                let matchCategory = selectedCategory == "Tous" || product.category == selectedCategory
                
                // Filtre par Nombre de personnes (si maxPeople est renseigné)
                let matchGuests = (product.maxPeople ?? 99) >= guestCount
                
                // On combine tout
                return matchSearch && matchCategory && matchGuests
            }) { product in
                NavigationLink(destination: ProductDetailView(product: product)) {
                    ProductCard(product: product)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal)
    }
    
    private var filterSheetContent: some View {
        NavigationStack {
            VStack(spacing: 25) {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Disponibilité")
                        .font(.headline)
                    
                    DatePicker("Arrivée", selection: $startDate, displayedComponents: .date)
                    DatePicker("Départ", selection: $endDate, displayedComponents: .date)
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Voyageurs")
                        .font(.headline)
                    
                    Stepper("Nombre de personnes : \(guestCount)", value: $guestCount, in: 1...20)
                }
                
                Spacer()
                
                Button(action: { showFilterSheet = false }) {
                    Text("Appliquer les filtres")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding()
            .navigationTitle("Filtres")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Réinitialiser") {
                        guestCount = 1
                        startDate = Date()
                        selectedCategory = "Tous"
                    }
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
    
    private var emptyState: some View {
        VStack(spacing: 15) {
            Spacer(minLength: 100)
            Image(systemName: "bag.badge.plus")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.4))
            Text("Aucun article disponible")
                .font(.headline)
                .foregroundColor(.secondary)
            Button("Rafraîchir") {
                Task { await viewModel.fetchProducts() }
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity)
    }
}
