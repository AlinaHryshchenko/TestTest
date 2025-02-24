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
                        CustomTextField(placeholder: "Your name", text: $viewModel.name) // Name input field
                        CustomTextField(placeholder: "Email", text: $viewModel.email, isEmail: true) // Email input field
                        CustomTextField(placeholder: "Phone", text: $viewModel.phone, isPhone: true) // Phone input field
                       
                        // Position selection
                        Text("Select your position")
                            .font(.custom(NutinoSansFont.regular.rawValue, size: 18))
                            .foregroundColor(Color(Colors.textDarkDrayColor))
                            .padding(.top, 10)
                        
                        if isLoadingPositions {
                            ProgressView("Loading positions...")
                                .padding(.top, 10)
                        } else {
                            // List of positions
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
                        Spacer(minLength: 10)
                        
                        // Photo upload section
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
                            .disabled(!viewModel.canSignUp || viewModel.isLoading)
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 16)
                }
                // Bottom tab bar
                BottomTabBar(selectedTab: $viewModel.selectedTab, navigateToSignUp: {
                    viewModel.navigateToSignUp()
                })
            }
            .toolbar(.hidden)
            .onAppear {
                if !viewModel.positions.isEmpty {
                    isLoadingPositions = false
                }
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
                    viewModel.selectedImage = newImage // Update selected image
                    viewModel.photoPath = viewModel.imageManager.saveImageToFile(image: newImage) // Save image to file
                    viewModel.isPhotoUploaded = viewModel.photoPath != nil
                }
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
