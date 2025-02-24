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
    func saveImageToFile(image: UIImage) -> String?
}

class ImageServices: ImageServicesProtocol {
    // Saves the selected image to the file system.
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
