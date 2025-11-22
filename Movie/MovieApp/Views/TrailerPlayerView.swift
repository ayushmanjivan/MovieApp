//
//  TrailerPlayerView.swift
//  MovieApp
//
//  Created by ayushman.soni on 22/11/25.
//

import SwiftUI

struct TrailerPlayerView: View {
    let video: Video
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Spacer()
                
                // YouTube Icon
                Image(systemName: "play.rectangle.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.red)
                
                Text(video.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text("Watch the trailer on YouTube")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                if let url = video.youtubeURL {
                    Button(action: {
                        openURL(url)
                        // Auto dismiss after opening
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            dismiss()
                        }
                    }) {
                        HStack {
                            Image(systemName: "play.circle.fill")
                            Text("Watch Trailer")
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
                } else {
                    Text("Trailer not available")
                        .foregroundColor(.secondary)
                        .padding()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
            .navigationTitle("Trailer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
