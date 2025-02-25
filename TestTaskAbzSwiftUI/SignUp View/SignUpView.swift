//
//  SignUpView.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 17/02/2025.
//

import Foundation
import SwiftUI
import PhotosUI

struct SignUpView<ViewModel: SignUpViewModelProtocol>: View {
    @ObservedObject private var viewModel: ViewModel
    @StateObject private var imagePickerViewModel = ImagePickerViewModel()
    @State private var isLoadingPositions = true
    @State private var isKeyboardVisible = false
    
    // MARK: - Initialization
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        // Show alerts for specific states
        if viewModel.showEmailAlreadyRegistered {
            AlertView(alertType: .showEmailAlreadyRegistered) {
                viewModel.showEmailAlreadyRegistered = false
            }
        } else if viewModel.showSuccessRegistered {
            AlertView(
                alertType: .showSuccessRegistered,
                dismissAction: {
                    viewModel.showSuccessRegistered = false
                },
                navigationAction: {
                    viewModel.navigateToSignUp()
                }
            )
        } else {
            VStack {
                // Top toolbar with title
                TopToolbar(title: "Working with POST request")
                Spacer()
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        CustomTextField(text: $viewModel.name, placeholder: "Your name") // Name input field
                        CustomTextField(text: $viewModel.email, placeholder: "Email", isEmail: true) // Email input field
                        CustomTextField(text: $viewModel.phone, placeholder: "Phone", isPhone: true) // Phone input field
                        
                        // Position selection
                        selectYourPosition
                        if isLoadingPositions {
                            ProgressView()
                                .padding(.top, 10)
                        } else {
                            // List of positions
                            listOfPositions
                        }
                        Spacer(minLength: 10)
                        uploadPhoto
                        
                        if let uploadErrorMessage = viewModel.uploadErrorMessage {
                            ErrorText(message: uploadErrorMessage)
                                .padding(.leading, 15)
                        }
                        
                        if let errorMessage = viewModel.errorMessage {
                            ErrorText(message: errorMessage)
                                .padding(.leading, 15)
                        }
                        Spacer()
                        
                        // Sign Up button
                        HStack {
                            Spacer()
                            Button(action: {
                                viewModel.registerUser()
                            }) {
                                textSignUp
                            }
                            .disabled(!viewModel.canSignUp || viewModel.isLoading)
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 16)
                }
                // Bottom tab bar
                if !isKeyboardVisible {
                    BottomTabBar(selectedTab: $viewModel.selectedTab, navigateToSignUp: {
                        viewModel.navigateToSignUp()
                    })
                }
            }
            .toolbar(.hidden)
            .onAppear {
                if !viewModel.positions.isEmpty {
                    isLoadingPositions = false
                }
                
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { _ in
                    isKeyboardVisible = true
                }
                
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                    isKeyboardVisible = false
                }
            }
            .onDisappear {
                NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
            }
            
            .onChange(of: viewModel.positions) { newPositions in
                if !newPositions.isEmpty {
                    isLoadingPositions = false
                }
            }
            .actionSheet(isPresented: $imagePickerViewModel.showActionSheet) {
                ActionSheet(
                    title: Text("Choose how you want to add a photo"),
                    buttons: [
                        .default(Text("Camera"), action: {
                            imagePickerViewModel.showCameraPicker = true // Open camera
                        }),
                        .default(Text("Gallery"), action: {
                            imagePickerViewModel.showPhotoPicker = true // Open photo gallery
                        }),
                        .cancel()
                    ]
                )
            }
            .sheet(isPresented: $imagePickerViewModel.showPhotoPicker) {
                PhotoPicker(image: $imagePickerViewModel.image)  // Show photo picker
            }
            .fullScreenCover(isPresented: $imagePickerViewModel.showCameraPicker) {
                CameraPicker(image: $imagePickerViewModel.image) // Show camera picker
                    .ignoresSafeArea()
            }
            .onChange(of: imagePickerViewModel.image) { newImage in
                if let newImage = newImage {
                    viewModel.handleSelectedImage(newImage)
                }
            }
            
            if let uploadErrorMessage = viewModel.uploadErrorMessage {
                ErrorText(message: uploadErrorMessage)
                    .padding(.leading, 15)
            }
        }
    }
    
    var selectYourPosition: some View {
        Text("Select your position")
            .font(.custom(NutinoSansFont.regular.rawValue, size: 18))
            .foregroundColor(Color(Colors.textDarkDrayColor))
            .padding(.top, 10)
    }
    
    var uploadPhoto: some View {
        HStack {
            Text("Upload your photo")
                .foregroundColor(viewModel.uploadErrorMessage == nil
                                 ? Color(Colors.textGrayColor)
                                 : Color(Colors.redColor))
                .font(.custom(NutinoSansFont.regular.rawValue, size: 16))
            Spacer()
            
            Button(action: {
                imagePickerViewModel.showActionSheet = true
            }) {
                Text("Upload")
                    .foregroundColor(Color(Colors.textBlueColor))
                    .font(.custom(NutinoSansFont.regular.rawValue, size: 16))
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(viewModel.uploadErrorMessage != nil
                        ? Color(Colors.redColor)
                        : Color(Colors.tFBorderColor), lineWidth: 1)
        )
        
    }
    
    var textSignUp: some View {
        Text("Sign up")
            .font(.custom(NutinoSansFont.regular.rawValue, size: 16))
            .foregroundColor(viewModel.canSignUp
                             ? Color(Colors.textDarkDrayColor)
                             : Color(Colors.textLightGrayColor))
            .frame(minWidth: 140, maxHeight: 50)
            .padding()
            .background(viewModel.canSignUp
                        ? Color(Colors.yellowColor)
                        : Color(Colors.grayColor))
            .cornerRadius(24)
    }
    
    
    var listOfPositions: some View {
        ForEach(viewModel.positions, id: \.id) { position in
            HStack {
                Image(viewModel.selectedPosition?.id == position.id ? "BlueRound" : "GrayRound")
                    .foregroundColor(.blue)
                
                Text(position.name)
                    .font(.custom(NutinoSansFont.regular.rawValue, size: 16))
                    .foregroundColor(Color(Colors.textDarkDrayColor))
                    .padding(.leading, 15)
            }
            .padding(.top, 10)
            .padding(.leading, 15)
            .onTapGesture {
                viewModel.selectedPosition = position
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        let imageManager = ImageServices()
        let networkManager = NetworkManager()
        let coordinator = MainCoordinator(rootNavigationController: UINavigationController())
        let signUpCoordinator = SignUpCoordinator(mainCoordinator: coordinator, imageManager: imageManager, networkManager: networkManager)
        
        let existingEmails: Set<String> = []
        
        let viewModel = SignUpViewModel(
            imageManager: imageManager,
            coordinator: signUpCoordinator,
            networkManager: networkManager,
            existingEmails: existingEmails
        )
        
        return SignUpView(viewModel: viewModel)
    }
}
