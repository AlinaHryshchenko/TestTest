//
//  ImagePickerViewModel.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 20/02/2025.
//

import Foundation
import SwiftUI
import PhotosUI

class ImagePickerViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var showPhotoPicker = false
    @Published var showCameraPicker = false
    @Published var showActionSheet = false
}
