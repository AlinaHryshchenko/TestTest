//
//  ImageManager.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 18/02/2025.
//

import Foundation
import UIKit
import _PhotosUI_SwiftUI

protocol ImageServicesProtocol {
    func handlePhotoSelection(_ newItem: PhotosPickerItem?, completion: @escaping (UIImage?, String?, String?) -> Void)
    func saveImageToFile(image: UIImage) -> String?
}

class ImageServices: ImageServicesProtocol {
    func handlePhotoSelection(_ newItem: PhotosPickerItem?, completion: @escaping (UIImage?, String?, String?) -> Void) {
        guard let newItem else {
            completion(nil, nil, "No photo selected")
            return
        }
        
        Task {
            do {
                if let data = try await newItem.loadTransferable(type: Data.self),
                   let image = UIImage(data: data),
                   let jpegData = image.jpegData(compressionQuality: 0.8) {
                    let isValidSize = image.size.width >= 70 && image.size.height >= 70
                    let isValidFormat = newItem.supportedContentTypes.contains(.jpeg) || newItem.supportedContentTypes.contains(.image)
                    let isValidFileSize = jpegData.count <= 5_000_000
                    
                    if isValidSize && isValidFormat && isValidFileSize {
                        let photoPath = saveImageToFile(image: image)
                        completion(image, photoPath, nil)
                    } else {
                        completion(nil, nil, "Photo is required")
                    }
                }
            } catch {
                completion(nil, nil, "Failed to load image")
            }
        }
    }
    
    func saveImageToFile(image: UIImage) -> String? {
        if let data = image.jpegData(compressionQuality: 0.8) {
            let filename = UUID().uuidString + ".jpg"
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
            do {
                try data.write(to: url)
                return url.path
            } catch {
                print("Error saving photo: \(error)")
                return nil
            }
        }
        return nil
    }
}
