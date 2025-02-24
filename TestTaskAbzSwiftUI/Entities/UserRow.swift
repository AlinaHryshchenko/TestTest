//
//  UserRow.swift
//  TestTaskAbzSwiftUI
//
//  Created by Alina Hryshchenko on 23/02/2025.
//

import Foundation
import SwiftUI

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
                    .foregroundColor(Color(Colors.textDarkDrayColor))
                    .lineLimit(nil)
                
                Spacer(minLength: 0)
                
                Text(user.position)
                    .font(.custom(NutinoSansFont.light.rawValue, size: 14))
                    .foregroundColor(Color(Colors.textLightGrayColor))
                    .lineLimit(nil)
                
                Spacer(minLength: 0)
                
                Text(user.email)
                    .font(.custom(NutinoSansFont.regular.rawValue, size: 14))
                    .foregroundColor(Color(Colors.textDarkDrayColor))
                    .lineLimit(nil)
                
                Spacer(minLength: 5)
                
                Text(user.phone)
                    .font(.custom(NutinoSansFont.regular.rawValue, size: 14))
                    .foregroundColor(Color(Colors.textDarkDrayColor))
                    .lineLimit(nil)
            }
        }
        .padding(.vertical, 15)
    }
}
