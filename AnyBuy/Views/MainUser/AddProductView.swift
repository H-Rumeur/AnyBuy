import SwiftUI
import PhotosUI
import CoreLocation

struct AddProductView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authVM: AuthViewModel
    @StateObject var viewModel = ProductViewModel()
    
    @State private var name = ""
    @State private var price = ""
    @State private var description = ""
    @State private var category = "Mode"
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var address = ""
    
    let categories = ["Mode", "High-Tech", "Maison", "Loisirs", "Autre"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Photo de l'article") {
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        if let selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .clipped()
                                .cornerRadius(10)
                        } else {
                            Label("Ajouter une photo", systemImage: "camera")
                                .frame(maxWidth: .infinity)
                                .frame(height: 150)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                        }
                    }
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let image = UIImage(data: data) {
                                selectedImage = image
                            }
                        }
                    }
                }

                Section("Informations générales") {
                    TextField("Nom de l'article", text: $name)
                    TextField("Prix (€)", text: $price)
                        .keyboardType(.decimalPad)
                    
                    Picker("Catégorie", selection: $category) {
                        ForEach(categories, id: \.self) { cat in
                            Text(cat)
                        }
                    }
                }

                Section("Localisation") {
                    TextField("Adresse (ex: 10 rue de la Paix, Paris)", text: $address)
                }
                
                Section("Description") {
                    TextEditor(text: $description)
                        .frame(height: 100)
                }
                
                Button {
                    saveProduct()
                } label: {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("Mettre en vente")
                            .bold()
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(name.isEmpty || price.isEmpty || selectedImage == nil || address.isEmpty)
            }
            .navigationTitle("Nouvelle annonce")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
            }
        }
    }
    
    func saveProduct() {
        guard let image = selectedImage else { return }
        
        Task {
            // 1. Géocodage
            let geocoder = CLGeocoder()
            let placemarks = try? await geocoder.geocodeAddressString(address)
            let location = placemarks?.first?.location
            
            // 2. Tentative d'upload
            print("DEBUG: Début upload image...")
            guard let url = await viewModel.uploadImage(image) else {
                print("DEBUG: L'upload a échoué (URL est nil)")
                // Optionnel: ajouter une alerte ici pour prévenir l'utilisateur
                return
            }
            
            // 3. Création de l'objet
            let newProduct = Product(
                id: nil,
                ownerId: authVM.currentUser!.id,
                title: name,
                description: description,
                price: Double(price) ?? 0,
                category: category,
                imageUrl: url,
                latitude: location?.coordinate.latitude ?? 48.8566,
                longitude: location?.coordinate.longitude ?? 2.3522
            )
            
            // 4. Enregistrement final
            print("DEBUG: Envoi du produit à la base...")
            await viewModel.addProduct(product: newProduct, image: nil)
            
            // 5. Quitter la vue
            dismiss()
        }
    }
}
