//
//  CastMemberView.swift
//  MovieApp
//
//  Created by ayushman.soni on 22/11/25.
//

import SwiftUI

struct CastMemberView: View {
    let cast: Cast
    
    var body: some View {
        VStack {
            if let profilePath = cast.profilePath,
               let url = URL(string: "\(Config.imageBaseURL)\(profilePath)") {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "person.fill")
                                .foregroundColor(.gray)
                        )
                }
                .frame(width: 80, height: 120)
                .cornerRadius(8)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 120)
                    .cornerRadius(8)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                    )
            }
            
            Text(cast.name)
                .font(.caption)
                .lineLimit(2)
                .frame(width: 80)
                .multilineTextAlignment(.center)
            
            Text(cast.character)
                .font(.caption2)
                .foregroundColor(.secondary)
                .lineLimit(2)
                .frame(width: 80)
                .multilineTextAlignment(.center)
        }
    }
}
