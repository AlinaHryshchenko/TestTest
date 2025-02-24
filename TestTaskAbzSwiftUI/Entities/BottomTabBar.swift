//
//  BottomTabBar.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 17/02/2025.
//

import Foundation
import SwiftUI

struct BottomTabBar: View {
    @Binding var selectedTab: Int
    var navigateToSignUp: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            // Users Tab Button
            Button(action: {
                if selectedTab != 0 {
                    selectedTab = 0
                    navigateToSignUp()
                }
            }) {
                HStack {
                    Image(selectedTab == 0 
                          ? "ThreePearsonBlue"
                          : "ThreePearsonDark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    
                    Text("Users")
                        .font(.custom("Nunito Sans", size: 16))
                        .foregroundColor(selectedTab == 0
                                         ? Color(Colors.blueColor)
                                         : Color(Colors.textGrayColor)
                )}
                .padding()
            }
            .disabled(selectedTab == 0)
            Spacer()
            // Sign Up Tab Button
            Button(action: {
                if selectedTab != 1 {
                    selectedTab = 1
                    navigateToSignUp()
                }
            }) {
                HStack {
                    Image(selectedTab == 1 
                          ? "AddPearsonBlue"
                          : "AddPearsonDark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    
                    Text("Sign up")
                        .font(.custom("Nunito Sans", size: 16))
                        .foregroundColor(selectedTab == 1
                                         ? Color(Colors.blueColor)
                                         : Color(Colors.textGrayColor)
                )}
                .padding()
            }
            .disabled(selectedTab == 1)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color(Colors.lightGrayColor))
    }
}





