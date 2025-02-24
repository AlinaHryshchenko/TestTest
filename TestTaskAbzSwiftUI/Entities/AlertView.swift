//
//  Alert.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 23/02/2025.
//

import Foundation
import SwiftUI

enum AlertType {
    case showSuccessRegistered
    case showEmailAlreadyRegistered
    case noUsers
}

struct AlertView: View {
    var alertType: AlertType
    var dismissAction: () -> Void
    var navigationAction: (() -> Void)?
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.white.opacity(0.8)
                .edgesIgnoringSafeArea(.all)
                .overlay(
                    VStack {
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                        
                        Text(message)
                            .padding()
                            .font(.custom(NutinoSansFont.regular.rawValue, size: 16))
                            .foregroundColor(Color(Colors.textDarkDrayColor))
                        
                        if showButton {
                            Button(buttonText) {
                                if alertType == .showSuccessRegistered {
                                    navigationAction?()
                                } else {
                                    dismissAction() 
                                }
                            }
                            .font(.custom(NutinoSansFont.regular.rawValue, size: 16))
                            .foregroundColor(Color(Colors.textDarkDrayColor))
                            .frame(minWidth: 140, maxHeight: 50)
                            .background(Color(Colors.yellowColor))
                            .cornerRadius(24)
                        }
                    }
                )
            
            if showCloseButton {
                Button(action: {
                    dismissAction()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .padding()
                }
                .padding()
            }
        }
    }
    
    private var imageName: String {
        switch alertType {
        case .showSuccessRegistered:
            return "SuccessRegistered"
        case .showEmailAlreadyRegistered:
            return "EmailAlreadyRegistered"
        case .noUsers:
            return "NoUsers"
        }
    }
    
    private var message: String {
        switch alertType {
        case .showSuccessRegistered:
            return "User successfully registered"
        case .showEmailAlreadyRegistered:
            return "That email is already registered"
        case .noUsers:
            return "There are no users yet"
        }
    }
    
    private var buttonText: String {
        switch alertType {
        case .showSuccessRegistered:
            return "Got it"
        case .showEmailAlreadyRegistered:
            return "Try again"
        case .noUsers:
            return ""
        }
    }
    
    private var showButton: Bool {
        switch alertType {
        case .noUsers:
            return false
        default:
            return true
        }
    }
    
    private var showCloseButton: Bool {
        switch alertType {
        case .noUsers:
            return false
        default:
            return true
        }
    }
}
