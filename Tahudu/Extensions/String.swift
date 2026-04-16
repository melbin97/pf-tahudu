//
//  String.swift
//  Tahudu
//
//  Created by Melbin Mathew on 16/04/26.
//

extension String {
    var pascalCase: String {
        return self.split(separator: "_")
            .map({ $0.capitalized }).joined()
    }
}
