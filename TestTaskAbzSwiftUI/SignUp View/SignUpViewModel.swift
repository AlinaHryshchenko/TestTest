//
//  SignUpViewModel.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 17/02/2025.
//

import Foundation
import _PhotosUI_SwiftUI

// MARK: - SignUpViewModelProtocol
protocol SignUpViewModelProtocol: ObservableObject {
    var name: String { get set }
    var email: String { get set }
    var phone: String { get set }
    var selectedPosition: Position? { get set }
    var isPhotoUploaded: Bool { get set }
    var selectedImage: UIImage? { get set }
    var photoPath: String? { get set }
    var uploadErrorMessage: String? { get set }
    var isLoading: Bool { get set }
    var showError: Bool { get set }
    var errorMessage: String? { get set }
    var positions: [Position] { get set }
    var canSignUp: Bool { get }
    var selectedTab: Int { get set }
    var imageManager: ImageServicesProtocol { get set }
    var showEmailAlreadyRegistered: Bool { get set }
    var showSuccessRegistered: Bool { get set }
    func registerUser()
    func navigateToSignUp()
    func loadPositions()
    func handleSelectedImage(_ image: UIImage)
}

final class SignUpViewModel: SignUpViewModelProtocol, ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var selectedPosition: Position?
    @Published var isPhotoUploaded: Bool = false
    @Published var selectedImage: UIImage?
    @Published var photoPath: String?
    @Published var uploadErrorMessage: String?
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String?
    @Published var selectedTab: Int
    @Published var positions: [Position] = []
    @Published var showEmailAlreadyRegistered: Bool = false
    @Published var showSuccessRegistered: Bool = false
    
    var imageManager: ImageServicesProtocol
    private let networkManager: NetworkProtocol
    private var coordinator: SignUpCoordinatorProtocol
    private let existingEmails: Set<String>
    
    var canSignUp: Bool {
        ValidatorManager.isValid(name: name, email: email, phone: phone) &&
        !phone.isEmpty && isPhotoUploaded
    }
    
    // MARK: - Initialization
    init(
        imageManager: ImageServicesProtocol,
        coordinator: SignUpCoordinatorProtocol,
        networkManager: NetworkProtocol,
        existingEmails: Set<String>
    ) {
        self.imageManager = imageManager
        self.coordinator = coordinator
        self.networkManager = networkManager
        self.selectedTab = coordinator.selectedTab
        self.existingEmails = existingEmails
        loadPositions()
    }
    
    // MARK: - Navigation
    func navigateToSignUp() {
        coordinator.startUserListFlow()
    }
    
    // MARK: - User Registration
    func registerUser() {
        guard let photoPath = photoPath, let positionId = selectedPosition?.id else {
            errorMessage = "Photo and position are required"
            return
        }
        // Check if the email is already registered
        if existingEmails.contains(email) {
            showEmailAlreadyRegistered = true
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // Register user via network manager
        networkManager.registerUserWithDetails(
            name: name,
            email: email,
            phone: phone,
            positionId: positionId,
            photoPath: photoPath
        ) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    print(self?.errorMessage)
                } else if success {
                    self?.showSuccessRegistered = true
                    self?.coordinator.startUserListFlow()
                } else {
                    self?.errorMessage = "Registration failed"
                }
            }
        }
    }
    
    // Fetches the list of available positions from the server.
    func loadPositions() {
        networkManager.fetchPositions { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedPositions):
                    self?.positions = fetchedPositions
                case .failure(let error):
                    print("Error fetching positions: \(error)")
                }
            }
        }
    }
    
    // Validates the selected photo based on size and file size requirements.
    func validatePhoto(_ image: UIImage) -> Bool {
        let isValidSize = image.size.width >= 70 && image.size.height >= 70
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            let isValidFileSize = jpegData.count <= 5_000_000
            return isValidSize && isValidFileSize
        }
        return false
    }
    
    // Handles the selected image by validating it and updating the state.
    func handleSelectedImage(_ image: UIImage) {
        if validatePhoto(image) {
            selectedImage = image
            photoPath = imageManager.saveImageToFile(image: image)
            isPhotoUploaded = true
            uploadErrorMessage = nil
        } else {
            isPhotoUploaded = false
            uploadErrorMessage = "Photo is required"
        }
    }
}
