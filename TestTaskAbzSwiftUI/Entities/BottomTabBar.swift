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
            Button(action: {
                selectedTab = 0
                navigateToSignUp()
            }) {
                HStack {
                    Image("ThreePearson")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    
                    Text("Users")
                        .font(.custom("Nunito Sans", size: 16))
                        .foregroundColor(Color("BlueColor", bundle: nil))
                }
                .padding()
            }
            Spacer()
            Button(action: {
                selectedTab = 1
                navigateToSignUp()
            }) {
                HStack {
                    Image("AddPearsonDark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    
                    Text("Sign up")
                        .font(.custom("Nunito Sans", size: 16))
                        .foregroundColor(Color("TextGrayColor", bundle: nil))
                }
                .padding()
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.gray)
    }
}





