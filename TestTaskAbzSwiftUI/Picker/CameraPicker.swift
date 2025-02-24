//
//  CameraPicker.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 20/02/2025.
//

import Foundation
import UIKit
import SwiftUI

struct CameraPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    //Creates and configures the `UIImagePickerController`.
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    // Updates the view controller (not used in this case).
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
   
    // Creates a coordinator to handle `UIImagePickerController` delegate methods.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Coordinator Class
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraPicker

        init(_ parent: CameraPicker) {
            self.parent = parent
        }

        // Called when an image is captured or selected.
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }
        
        // Called when the user cancels the image capture.
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
