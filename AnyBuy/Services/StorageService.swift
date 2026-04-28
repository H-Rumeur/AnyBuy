//
//  StorageService.swift
//  AnyBuy
//
//  Created by User on 22/04/26.
//

import Foundation
import UIKit
import Supabase

class StorageService {
    static let shared = StorageService()
    private let client = SupabaseManager.shared.client
    
    func uploadImage(data: Data, bucket: String) async throws -> String {
        let fileName = "\(UUID().uuidString).jpg"
        let filePath = "\(fileName)"
        
        try await client.storage
            .from(bucket)
            .upload(path: filePath, file: data, options: FileOptions(contentType: "image/jpeg"))
            
        let url = try client.storage.from(bucket).getPublicURL(path: filePath)
        return url.absoluteString
    }
}
