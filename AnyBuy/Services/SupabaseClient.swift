import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init() {
        // Remplace par tes vraies clés entre les guillemets
        let urlString = "https://njyqykmrflxzeopqllgs.supabase.co"
        let anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5qeXF5a21yZmx4emVvcHFsbGdzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY4MTUyODgsImV4cCI6MjA5MjM5MTI4OH0.h9zgAfqsTAeKoVt-onXn6PNUceovIunDluYNWZr7tBw"
        
        // Sécurité : On vérifie que l'URL est valide avant de créer le client
        guard let url = URL(string: urlString) else {
            fatalError("L'URL de Supabase est invalide. Vérifie le format dans SupabaseClient.swift")
        }
        
        // On initialise le client sans utiliser de "!"
        self.client = SupabaseClient(supabaseURL: url, supabaseKey: anonKey)
    }
}
