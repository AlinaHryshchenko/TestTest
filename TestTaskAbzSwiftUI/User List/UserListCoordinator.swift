//
//  UserListCoordinator.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 17/02/2025.
//

import Foundation
import SwiftUI

// MARK: - UserListCoordinatorProtocol
protocol UserListCoordinatorProtocol {
    func startSignUpFlow(existingEmails: Set<String>)
}

final class UserListCoordinator: UserListCoordinatorProtocol {
    var mainCoordinator: MainCoordinatorProtocol
    
    // MARK: - Initialization
    init(mainCoordinator: MainCoordinatorProtocol) {
        self.mainCoordinator = mainCoordinator
    }
    
    // Starts the Sign Up flow by creating the necessary ViewModel and View.
    func startSignUpFlow(existingEmails: Set<String>) { 
            let signUpViewModel = SignUpViewModel(
                imageManager: ImageServices(),
                coordinator: SignUpCoordinator(
                    mainCoordinator: mainCoordinator,
                    imageManager: ImageServices(),
                    networkManager: NetworkManager()
                ),
                networkManager: NetworkManager(),
                existingEmails: existingEmails
            )
            let signUpView = SignUpView(viewModel: signUpViewModel)
            let hostingController = UIHostingController(rootView: signUpView)
        mainCoordinator.startSignUpFlow(existingEmails: existingEmails)
    }
   
    // Initializes and starts the User List flow.
    func start() {
        let viewModel = UserListViewModel(networkService: NetworkManager(),
                                          coordinator: self,
                                          networkMonitor: NetworkMonitor())
        let view = UserListView(viewModel: viewModel)
        let host = UIHostingController(rootView: view)
        
        mainCoordinator.setRootController(host)
    }
    
}
