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
    func registerUser()
    func navigateToSignUp()
    func loadPositions()
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
    
    var imageManager: ImageServicesProtocol
    private let networkManager: NetworkProtocol
    var coordinator: SignUpCoordinatorProtocol

    
    var canSignUp: Bool {
        ValidatorManager.isValid(name: name, email: email, phone: phone) &&
        !phone.isEmpty && isPhotoUploaded
    }
    
    init(imageManager: ImageServicesProtocol, coordinator: SignUpCoordinatorProtocol, networkManager: NetworkProtocol) {
        self.imageManager = imageManager
        self.coordinator = coordinator
        self.networkManager = networkManager
        self.selectedTab = (coordinator as? MainCoordinator)?.selectedTab ?? 1
        loadPositions()
    }
    
    func navigateToSignUp() {
        coordinator.startUserListFlow()
    }
    
    func registerUser() {
            guard let photoPath = photoPath, let positionId = selectedPosition?.id else {
                errorMessage = "Photo and position are required"
                return
            }
            
            isLoading = true
            errorMessage = nil
            
            networkManager.registerUserWithDetails(name: name, email: email, phone: phone, positionId: positionId, photoPath: photoPath) { [weak self] success, error in
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
    
    func loadPositions() {
        networkManager.fetchPositions { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedPositions):
                    self?.positions = fetchedPositions
                    print("Fetched positions: \(fetchedPositions)")
                case .failure(let error):
                    print("Error fetching positions: \(error)")
                }
            }
        }
    }
}
