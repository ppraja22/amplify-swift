//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

public struct AWSPinpointAnalyticsPluginOptions {
    public static let defaultAutoFlushEventsInterval: UInt = 60
    public static let defaultTrackAppSession = true
    public static let defaultAutoSessionTrackingInterval: UInt = {
    #if os(macOS)
        .max
    #else
        5
    #endif
    }()

    public let autoFlushEventsInerval: UInt
    public let trackAppSessions: Bool
    public let autoSessionTrackingInterval: UInt

    public init(autoFlushEventsInerval: UInt = defaultAutoFlushEventsInterval,
                trackAppSessions: Bool = defaultTrackAppSession,
                autoSessionTrackingInterval: UInt = defaultAutoSessionTrackingInterval) {
        self.autoFlushEventsInerval = autoFlushEventsInerval
        self.trackAppSessions = trackAppSessions
        self.autoSessionTrackingInterval = autoSessionTrackingInterval
    }
}