//
//  ErrorView.swift
//  RecipeReady
//
//  Created by ovi on 8/14/24.
//

import SwiftUI

struct ErrorView: View {
    
    // Typealias for the error handler closure to make the code more readable.
    typealias ErrorViewActionHandler = () -> Void
    
    let error: Error
    
    // The handler that will be called when the user taps the retry button.
    let handler: ErrorViewActionHandler
    
    // Custom init that passes in the error and the retry handler.
    internal init(error: Error,
                  // We mark the handler with @escaping because it's called after the initializer completes.
                  handler: @escaping ErrorView.ErrorViewActionHandler) {
        self.error = error
        self.handler = handler
    }
    
    var body: some View {
        VStack(spacing: 25) {
            // Display an icon, "Woops" text, and the error description.
            VStack(spacing: 15) {
                Image(systemName: "exclamationmark.icloud.fill")
                    .foregroundColor(.gray)
                    .font(.system(size: 50, weight: .heavy))
                
                Text("Woops")
                    .foregroundColor(.black)
                    .font(.system(size: 30, weight: .heavy))
                
                // Localized description of the error.
                Text("\(error.localizedDescription)")
                    .foregroundColor(.gray)
                    .font(.system(size: 15))
                    .multilineTextAlignment(.center)
            }
            
            // Retry button that triggers the provided handler closure when tapped.
            Button {
                handler()
            } label: {
                Text("Retry")
            }
            .padding(13) // Inner padding
            .padding(.horizontal) // Additional horizontal padding
            .background(Color(uiColor: .systemBlue))
            .foregroundColor(.white)
            .font(.title2)
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Make the error view take up the entire screen
        .background(Color(uiColor: .secondarySystemBackground))
    }
}

#Preview {
    ErrorView(error: APIError.decodingError) {}
}

