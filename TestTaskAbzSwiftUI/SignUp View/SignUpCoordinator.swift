//
//  SignUpCoordinator.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 17/02/2025.
//

import Foundation
import SwiftUI

// MARK: - SignUpCoordinatorProtocol
protocol SignUpCoordinatorProtocol {
    func start(existingEmails: Set<String>)
    func startUserListFlow()
}

final class SignUpCoordinator: SignUpCoordinatorProtocol {
    let mainCoordinator: MainCoordinatorProtocol
    var imageManager: ImageServicesProtocol
    var networkManager: NetworkProtocol
    
    // MARK: - Initialization
    init(mainCoordinator: MainCoordinatorProtocol, imageManager: ImageServices, networkManager: NetworkManager) {
        self.mainCoordinator = mainCoordinator
        self.imageManager = imageManager
        self.networkManager = networkManager
    }
    
    // MARK: - Start Sign Up Flow
    // Starts the Sign Up flow by creating the necessary ViewModel and View.
    func start(existingEmails: Set<String>) {
           let viewModel = SignUpViewModel(
               imageManager: imageManager,
               coordinator: self,
               networkManager: networkManager,
               existingEmails: existingEmails
           )
           let view = SignUpView(viewModel: viewModel)
           let host = UIHostingController(rootView: view)
           mainCoordinator.setRootController(host)
       }
    
    // Navigates to the User List flow.
    func startUserListFlow() {
        mainCoordinator.startUserListFlow()
    }
}

