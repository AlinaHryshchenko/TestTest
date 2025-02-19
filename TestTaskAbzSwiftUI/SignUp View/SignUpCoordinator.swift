//
//  SignUpCoordinator.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 17/02/2025.
//

import Foundation
import SwiftUI

protocol SignUpCoordinatorProtocol {
    func start()
    func startUserListFlow()
}

final class SignUpCoordinator: SignUpCoordinatorProtocol {
    let mainCoordinator: MainCoordinatorProtocol
    var imageManager: ImageServicesProtocol
    var networkManager: NetworkProtocol
    
    init(mainCoordinator: MainCoordinatorProtocol, imageManager: ImageServices, networkManager: NetworkManager) {
        self.mainCoordinator = mainCoordinator
        self.imageManager = imageManager
        self.networkManager = networkManager
    }
    
    func start() {
        let viewModel = SignUpViewModel(imageManager: imageManager, coordinator: self, networkManager: networkManager)
        let view = SignUpView(viewModel: viewModel)
        let host = UIHostingController(rootView: view)
        
        mainCoordinator.setRootController(host)
    }
    
    func startUserListFlow() {
        mainCoordinator.startHomeFlow()
    }
}

