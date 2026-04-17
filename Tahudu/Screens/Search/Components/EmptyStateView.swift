//
//  EmptyStateView.swift
//  Tahudu
//
//  Created by Melbin Mathew on 17/04/26.
//
import SwiftUI

struct EmptyStateView: View {
    var emptyState: EmptyState
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
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
            Spacer()
        }
    }
}


#Preview {
    EmptyStateView(emptyState: .noData)
}
