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
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            TopToolbar(title: "Working with GET request")
                .padding(.top, 5)
            
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
            
            Spacer()
            
            BottomTabBar(selectedTab: $viewModel.selectedTab, navigateToSignUp: {
                viewModel.navigateToSignUp()
            })
        }
        .onAppear {
            viewModel.loadUsers(nextPageLink: nil)
        }
    }
}

struct UserRow: View {
    let user: User
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: URL(string: user.photo)) { image in
                image.resizable()
            } placeholder: {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .foregroundColor(.gray)
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            .padding(.horizontal, 10)
            
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.custom(NutinoSansFont.regular.rawValue, size: 18))
                    .foregroundColor(Color("TextDarkDrayColor", bundle: nil))
                    .lineLimit(nil)
                
                Spacer(minLength: 0)
                
                Text(user.position)
                    .font(.custom(NutinoSansFont.light.rawValue, size: 14))
                    .foregroundColor(Color("TextLightGrayColor", bundle: nil))
                    .lineLimit(nil)
                
                Spacer(minLength: 0)
                
                Text(user.email)
                    .font(.custom(NutinoSansFont.regular.rawValue, size: 14))
                    .foregroundColor(Color("TextDarkDrayColor", bundle: nil))
                    .lineLimit(nil)
                
                Spacer(minLength: 5)
                
                Text(user.phone)
                    .font(.custom(NutinoSansFont.regular.rawValue, size: 14))
                    .foregroundColor(Color("TextDarkDrayColor", bundle: nil))
                    .lineLimit(nil)
            }
        }
        .padding(.vertical, 15)
    }
}

#Preview {
    UserListView(viewModel: UserListViewModel(
        networkService: NetworkManager(),
        coordinator: UserListCoordinator(
            mainCoordinator: MainCoordinator(
                rootNavigationController: UINavigationController()))))
}




