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
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            TopToolbar(title: "Working with POST request")
                .padding(.top, 5)
            Spacer()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    CustomTextField(placeholder: "Your name", text: $viewModel.name)
                    CustomTextField(placeholder: "Email", text: $viewModel.email, isEmail: true)
                    CustomTextField(placeholder: "Phone", text: $viewModel.phone, isPhone: true)
                    
                    Text("Select your position")
                        .font(.custom(NutinoSansFont.regular.rawValue, size: 18))
                        .foregroundColor(Color(Colors.textDarkDrayColor.rawValue))
                        .padding(.top, 10)
                    
                    ForEach(viewModel.positions, id: \.self) { position in
                        HStack {
                            Image(viewModel.selectedPosition == position ? "BlueRound" : "GrayRound")
                                .foregroundColor(.blue)
                            Text(position.rawValue)
                                .font(.custom(NutinoSansFont.regular.rawValue, size: 16))
                                .foregroundColor(Color(Colors.textDarkDrayColor.rawValue))
                                .padding(.leading, 15)
                        }
                        .padding(.top, 10)
                        .padding(.leading, 15)
                        .onTapGesture {
                            viewModel.selectedPosition = position
                        }
                    }
                    
                    Spacer(minLength: 10)
                    HStack {
                        Text("Upload your photo")
                            .foregroundColor(viewModel.uploadErrorMessage == nil ? Color(Colors.textGrayColor.rawValue) : Color(Colors.redColor.rawValue))
                            .font(.custom(NutinoSansFont.regular.rawValue, size: 16))
                        Spacer()
                        
                        Button(action: {
                            imagePickerViewModel.showActionSheet = true
                        }) {
                            Text("Upload")
                                .foregroundColor(Color(Colors.textBlueColor.rawValue))
                                .font(.custom(NutinoSansFont.regular.rawValue, size: 16))
                        }
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(viewModel.uploadErrorMessage != nil ? Color(Colors.redColor.rawValue) : Color(Colors.tFBorderColor.rawValue), lineWidth: 1)
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
                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.registerUser()
                        }) {
                            Text("Sign up")
                                .font(.custom(NutinoSansFont.regular.rawValue, size: 16))
                                .foregroundColor(viewModel.canSignUp
                                                 ? Color(Colors.textDarkDrayColor.rawValue)
                                                 : Color(Colors.textLightGrayColor.rawValue))
                                .frame(minWidth: 140, maxHeight: 50)
                                .padding()
                                .background(viewModel.canSignUp
                                            ? Color(Colors.yellowColor.rawValue)
                                            : Color(Colors.grayColor.rawValue))
                                .cornerRadius(24)
                        }
                        .disabled(!viewModel.canSignUp || viewModel.isLoading)
                        Spacer()
                    }
                }
                .padding(.horizontal, 16)
            }
            
            BottomTabBar(selectedTab: $viewModel.selectedTab, navigateToSignUp: {
                viewModel.navigateToSignUp()
            })
        }
        .actionSheet(isPresented: $imagePickerViewModel.showActionSheet) {
            ActionSheet(
                title: Text("Choose how you want to add a photo"),
                buttons: [
                    .default(Text("Camera"), action: {
                        imagePickerViewModel.showCameraPicker = true
                    }),
                    .default(Text("Gallery"), action: {
                        imagePickerViewModel.showPhotoPicker = true
                    }),
                    .cancel()
                ]
            )
        }
        .sheet(isPresented: $imagePickerViewModel.showPhotoPicker) {
            PhotoPicker(image: $imagePickerViewModel.image)
        }
        .fullScreenCover(isPresented: $imagePickerViewModel.showCameraPicker) {
            CameraPicker(image: $imagePickerViewModel.image)
                .ignoresSafeArea()
        }
        .onChange(of: imagePickerViewModel.image) { newImage in
            if let newImage = newImage {
                viewModel.selectedImage = newImage
                viewModel.photoPath = viewModel.imageManager.saveImageToFile(image: newImage)
                viewModel.isPhotoUploaded = viewModel.photoPath != nil
            }
        }
    }
}
    
struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var isEmail: Bool = false
    var isPhone: Bool = false
    
    var isValid: Bool {
        if text.isEmpty { return true }
        if isEmail {
            return ValidatorManager.isValidEmail(text)
        } else if isPhone {
            return ValidatorManager.isValidPhone(text)
        } else {
            return ValidatorManager.isValidName(text)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            TextField(placeholder, text: $text)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(isValid 
                                                                  ? Color(Colors.tFBorderColor.rawValue)
                                                                  : Color(Colors.redColor.rawValue),
                                                                  lineWidth: 1))
                .font(.custom(NutinoSansFont.regular.rawValue, size: 16))
            
            if isPhone && (text.isEmpty || isValid) {
                Text("+38 (XXX) XXX - XX - XX")
                    .foregroundColor(Color(Colors.textGrayColor.rawValue))
                    .font(.custom(NutinoSansFont.light.rawValue, size: 12))
                    .padding(.leading, 15)
                    .padding(.top, 3)
            }
            
            Text(isEmail ? "Invalid email format" : isPhone ? "Required field" : "Required field")
                .foregroundColor(Color(Colors.redColor.rawValue))
                .font(.custom(NutinoSansFont.light.rawValue, size: 12))
                .padding(.leading, 15)
                .padding(.top, 3)
                .opacity(isValid ? 0 : 1)
        }
    }
}


struct ErrorText: View {
    var message: String
    
    var body: some View {
        Text(message)
            .foregroundColor(Color(Colors.redColor.rawValue))
            .font(.custom(NutinoSansFont.light.rawValue, size: 12))
            .padding(.leading, 5)
    }
}

#Preview {
    SignUpView(viewModel: SignUpViewModel(
        imageManager: ImageServices(),
        coordinator: SignUpCoordinator(
            mainCoordinator: MainCoordinator(rootNavigationController: UINavigationController()),
            imageManager:  ImageServices(),
            networkManager: NetworkManager()),
        networkManager: NetworkManager()))
    
}
