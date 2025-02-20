//
//  SignUpViewModel.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 17/02/2025.
//

import Foundation
import _PhotosUI_SwiftUI

protocol SignUpViewModelProtocol: ObservableObject {
    var name: String { get set }
    var email: String { get set }
    var phone: String { get set }
    var selectedPosition: TypePosition { get set }
    var isPhotoUploaded: Bool { get set }
    var selectedImage: UIImage? { get set }
    var photoPath: String? { get set }
    var uploadErrorMessage: String? { get set }
    var isLoading: Bool { get set }
    var showError: Bool { get set }
    var errorMessage: String? { get set }
    var positions: [TypePosition] { get }
    var canSignUp: Bool { get }
    var selectedTab: Int { get set }
    var imageManager: ImageServicesProtocol { get set }
    func registerUser()
    func navigateToSignUp()
}

final class SignUpViewModel: SignUpViewModelProtocol, ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var selectedPosition: TypePosition = .frontend
    @Published var isPhotoUploaded: Bool = false
    @Published var selectedImage: UIImage?
    @Published var photoPath: String?
    @Published var uploadErrorMessage: String?
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String?
    @Published var selectedTab: Int

    var imageManager: ImageServicesProtocol
    private let networkManager: NetworkProtocol
    var coordinator: SignUpCoordinatorProtocol
    var positions: [TypePosition] = TypePosition.allCases
    
    var canSignUp: Bool {
        ValidatorManager.isValid(name: name, email: email, phone: phone) &&
        !phone.isEmpty && isPhotoUploaded
    }
    
    init(imageManager: ImageServicesProtocol, coordinator: SignUpCoordinatorProtocol, networkManager: NetworkProtocol) {
        self.imageManager = imageManager
        self.coordinator = coordinator
        self.networkManager = networkManager
        self.selectedTab = (coordinator as? MainCoordinator)?.selectedTab ?? 1

    }
    
    func navigateToSignUp() {
        coordinator.startUserListFlow()
    }
    
    func registerUser() {
           guard let photoPath = photoPath else {
               errorMessage = "Photo is required"
               return
           }
           
           isLoading = true
           errorMessage = nil
           
           networkManager.registerUserWithDetails(name: name, email: email, phone: phone, positionId: selectedPosition.id, photoPath: photoPath) { [weak self] success, error in
               DispatchQueue.main.async {
                   self?.isLoading = false
                   
                   if let error = error {
                       self?.errorMessage = error.localizedDescription
                   } else if success {
                       self?.errorMessage = nil
                   } else {
                       self?.errorMessage = "Registration failed"
                   }
               }
           }
       }
   }
