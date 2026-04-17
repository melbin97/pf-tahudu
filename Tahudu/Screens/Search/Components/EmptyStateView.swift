//
//  EmptyStateView.swift
//  Tahudu
//
//  Created by Melbin Mathew on 17/04/26.
//
import SwiftUI

struct EmptyStateView: View {
    var emptyState: EmptyState
    var retry: () async -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Spacer()
            Image(systemName: emptyState.sfIconName)
                .resizable()
                .renderingMode(.template)
                .frame(width: 30, height: 30)
                .foregroundStyle(.gray)
            Text(emptyState.description)
                .multilineTextAlignment(.center)
                .font(.body)
                .foregroundStyle(.gray)
            if emptyState == .apiError {
                Button {
                    Task {
                        await retry()
                    }
                } label: {
                    Text("Try Again")
                        .padding(.vertical, 4)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.brand)
            }
            Spacer()
        }
    }
}


#Preview {
    EmptyStateView(emptyState: .noData, retry: {})
}
