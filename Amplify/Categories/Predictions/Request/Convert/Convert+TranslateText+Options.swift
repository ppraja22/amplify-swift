//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

public extension Predictions.Convert.TranslateText {
    struct Options {
        /// The default NetworkPolicy for the operation. The default value will be `auto`.
        public let defaultNetworkPolicy: DefaultNetworkPolicy

        /// Extra plugin specific options, only used in special circumstances when the existing options do not provide
        /// a way to utilize the underlying storage system's functionality. See plugin documentation for expected
        /// key/values
        public let pluginOptions: Any?

        public init(
            defaultNetworkPolicy: DefaultNetworkPolicy = .auto,
            pluginOptions: Any? = nil
        ) {
            self.defaultNetworkPolicy = defaultNetworkPolicy
            self.pluginOptions = pluginOptions
        }
    }
}
