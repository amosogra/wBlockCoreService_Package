//
//  ContentBlockerTargets.swift
//  wBlock
//
//  Created by Alexander Skula on 5/25/25.
//

import Foundation

public enum Platform {
    case macOS
    case iOS
}

public struct ContentBlockerTargetInfo: Hashable {
    public let primaryCategory: FilterListCategory
    public let platform: Platform
    public let bundleIdentifier: String
    public let rulesFilename: String
    public let secondaryCategory: FilterListCategory?

    init(primaryCategory: FilterListCategory, platform: Platform, bundleIdentifier: String, rulesFilename: String, secondaryCategory: FilterListCategory? = nil) {
        self.primaryCategory = primaryCategory
        self.platform = platform
        self.bundleIdentifier = bundleIdentifier
        self.rulesFilename = rulesFilename
        self.secondaryCategory = secondaryCategory
    }

    // Implement Hashable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(bundleIdentifier)
    }

    public static func == (lhs: ContentBlockerTargetInfo, rhs: ContentBlockerTargetInfo) -> Bool {
        lhs.bundleIdentifier == rhs.bundleIdentifier
    }
}

public class ContentBlockerTargetManager {
    public static let shared = ContentBlockerTargetManager()

    public let targets: [ContentBlockerTargetInfo]

    private init() {
        targets = [
            // macOS Targets
            ContentBlockerTargetInfo(primaryCategory: .ads, platform: .macOS, bundleIdentifier: "syferlab.wBlock.wBlock-Ads-Privacy", rulesFilename: "rules_ads_privacy_macos.json", secondaryCategory: .privacy),
            ContentBlockerTargetInfo(primaryCategory: .security, platform: .macOS, bundleIdentifier: "syferlab.wBlock.wBlock-Security-Multipurpose", rulesFilename: "rules_security_multipurpose_macos.json", secondaryCategory: .multipurpose),
            ContentBlockerTargetInfo(primaryCategory: .annoyances, platform: .macOS, bundleIdentifier: "syferlab.wBlock.wBlock-Annoyances", rulesFilename: "rules_annoyances_macos.json"),
            ContentBlockerTargetInfo(primaryCategory: .foreign, platform: .macOS, bundleIdentifier: "syferlab.wBlock.wBlock-Foreign-Experimental", rulesFilename: "rules_foreign_experimental_macos.json", secondaryCategory: .experimental),
            ContentBlockerTargetInfo(primaryCategory: .custom, platform: .macOS, bundleIdentifier: "syferlab.wBlock.wBlock-Custom", rulesFilename: "rules_custom_macos.json"),

            // iOS Targets
            ContentBlockerTargetInfo(primaryCategory: .ads, platform: .iOS, bundleIdentifier: "syferlab.wBlock.wBlock-Ads", rulesFilename: "rules_ads_ios.json"),
            ContentBlockerTargetInfo(primaryCategory: .privacy, platform: .iOS, bundleIdentifier: "syferlab.wBlock.wBlock-Privacy", rulesFilename: "rules_privacy_ios.json"),
            ContentBlockerTargetInfo(primaryCategory: .security, platform: .iOS, bundleIdentifier: "syferlab.wBlock.wBlock-Security", rulesFilename: "rules_security_ios.json"),
            ContentBlockerTargetInfo(primaryCategory: .annoyances, platform: .iOS, bundleIdentifier: "syferlab.wBlock.wBlock-Annoyances", rulesFilename: "rules_annoyances_ios.json"),
            ContentBlockerTargetInfo(primaryCategory: .multipurpose, platform: .iOS, bundleIdentifier: "syferlab.wBlock.wBlock-Multipurpose", rulesFilename: "rules_multipurpose_ios.json"),
            ContentBlockerTargetInfo(primaryCategory: .foreign, platform: .iOS, bundleIdentifier: "syferlab.wBlock.wBlock-Foreign", rulesFilename: "rules_foreign_ios.json"),
            ContentBlockerTargetInfo(primaryCategory: .experimental, platform: .iOS, bundleIdentifier: "syferlab.wBlock.wBlock-Experimental", rulesFilename: "rules_experimental_ios.json"),
            ContentBlockerTargetInfo(primaryCategory: .custom, platform: .iOS, bundleIdentifier: "syferlab.wBlock.wBlock-Custom", rulesFilename: "rules_custom_ios.json")
        ]
    }

    public func targetInfo(forCategory category: FilterListCategory, platform: Platform) -> ContentBlockerTargetInfo? {
        return targets.first { $0.platform == platform && ($0.primaryCategory == category || $0.secondaryCategory == category) }
    }
    
    public func allTargets(forPlatform platform: Platform) -> [ContentBlockerTargetInfo] {
        return targets.filter { $0.platform == platform }
    }
}
