//
//  SettingsViewController.swift
//  Tahudu
//

import Foundation
import UIKit

class SettingsViewController: UITableViewController {
    
    override func loadView() {
        super.loadView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGroupedBackground
        tableView.tableFooterView = UIView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
    }
    
    override func numberOfSections(in _: UITableView) -> Int {
        Section.allCases.count
    }
    
    override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        return items(for: section).count
    }
    
    override func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = Section(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        let item = items(for: section)[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        
        cell.accessibilityIdentifier = item.accessibilityId
        cell.backgroundColor = .systemBackground
        cell.selectionStyle = .default
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(systemName: item.icon)
        cell.textLabel?.text = item.title
        cell.textLabel?.textColor = .label
        cell.textLabel?.textAlignment = .natural
        cell.detailTextLabel?.text = item.detail
        cell.detailTextLabel?.textColor = .secondaryLabel
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let section = Section(rawValue: indexPath.section) else { return }
        let item = items(for: section)[indexPath.row]
        item.action()
    }
}


extension SettingsViewController {
    
    enum Section: Int, CaseIterable {
        case preferences
        case support
    }
    
    struct SettingsItem {
        let title: String
        let detail: String?
        let icon: String
        let accessibilityId: String
        let action: () -> ()
    }
    
    private func items(for section: Section) -> [SettingsItem] {
        switch section {
        case .preferences:
            return [
                SettingsItem(title: "Language", detail: Locale.current.localizedString(
                    forLanguageCode: Bundle.main.preferredLocalizations.first ?? "en"
                ), icon: "textformat", accessibilityId: "SettingsCell_language", action: openSystemSettings),
                SettingsItem(title: "Country", detail: "United Arab Emirates", icon: "globe", accessibilityId: "SettingsCell_country", action: showCountrySelectionScreen),
                SettingsItem(title: "Notifications", detail: nil, icon: "app.badge", accessibilityId: "SettingsCell_notifications", action: showNotificationScreen)
            ]
        case .support:
            return [
                SettingsItem(title: "About", detail: nil, icon: "info.circle", accessibilityId: "SettingsCell_about", action: showAboutScreen),
                SettingsItem(title: "Feedback", detail: nil, icon: "text.bubble", accessibilityId: "SettingsCell_feedback", action: showFeedbackScreen)
            ]
        }
    }
}

// ===============================

/// NO NEED TO TUOCH THIS!!!
extension SettingsViewController {
    private func openSystemSettings() {
        print(#function)
    }
    
    private func showCountrySelectionScreen() {
        print(#function)
    }
    
    private func showNotificationScreen() {
        print(#function)
    }
    
    private func showAboutScreen() {
        print(#function)
    }
    
    private func showFeedbackScreen() {
        print(#function)
    }
}
