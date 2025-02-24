//
//  UserListView.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 17/02/2025.
//

import Foundation
import SwiftUI

struct UserListView<ViewModel: UserListViewModelProtocol>: View {
    @ObservedObject private var viewModel: ViewModel
  
    // MARK: - Initialization
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            TopToolbar(title: "Working with GET request")
           
            // Check internet connection
            if !viewModel.isConnected {
                VStack(spacing: 16) {
                    Image("NoInternetConnecton")
                        .resizable()
                        .frame(width: 200, height: 200)
                    
                    Text("No internet connection")
                        .font(.custom(NutinoSansFont.regular.rawValue, size: 20))
                        .foregroundColor(Color(Colors.textDarkDrayColor))
                    
                    Button("Try Again") {
                        viewModel.checkInternetConnection()
                    }
                    .font(.custom(NutinoSansFont.regular.rawValue, size: 16))
                    .foregroundColor(Color(Colors.textDarkDrayColor))
                    .frame(minWidth: 140, maxHeight: 50)
                    .background(Color(Colors.yellowColor))
                    .cornerRadius(24)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
               
                // Show alert if loading failed and no users are available
            } else if viewModel.hasLoadingFailed && viewModel.users.isEmpty {
                AlertView(alertType: .noUsers) {
                    viewModel.loadUsers(nextPageLink: nil)
                }
                // Display the list of users
            } else {
                List {
                    ForEach(viewModel.users) { user in
                        UserRow(user: user)
                            .onAppear {
                                viewModel.loadNextPageIfNeeded(currentItem: user)
                            }
                    }
                    if viewModel.isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                            Spacer()
                        }
                        .padding()
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color.white)
            }
            Spacer()
            
            // Bottom tab bar for navigation
            BottomTabBar(selectedTab: $viewModel.selectedTab, navigateToSignUp: {
                viewModel.navigateToSignUp()
            })
        }
        .toolbar(.hidden)
        .onAppear {
            // Load users when the view appears
            viewModel.loadUsers(nextPageLink: nil)
        }
    }
}

#Preview {
    UserListView(viewModel: UserListViewModel(
        networkService: NetworkManager(),
        coordinator: UserListCoordinator(
            mainCoordinator: MainCoordinator(
                rootNavigationController: UINavigationController())),
        networkMonitor: NetworkMonitor()))
}




