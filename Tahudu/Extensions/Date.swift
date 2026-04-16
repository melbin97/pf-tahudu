//
//  Date.swift
//  Tahudu
//
//  Created by Melbin Mathew on 16/04/26.
//
import Foundation

extension Date {
    func timeAgo() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
