//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Amplify
import Foundation

enum PasswordlessCustomAuthSignInMethod: String {
    case otp = "OTP"
    case magicLink = "MAGIC_LINK"
}

enum PasswordlessCustomAuthRequestAction: String {
    case request = "REQUEST"
    case confirm = "CONFIRM"
}

struct PasswordlessCustomAuthRequest {

    private let namespace = "Amplify.Passwordless"

    let signInMethod: PasswordlessCustomAuthSignInMethod
    let action: PasswordlessCustomAuthRequestAction
    let deliveryMedium: AuthPasswordlessDeliveryDestination?
    let redirectURL: String?

    init(signInMethod: PasswordlessCustomAuthSignInMethod,
         action: PasswordlessCustomAuthRequestAction,
         deliveryMedium: AuthPasswordlessDeliveryDestination? = nil,
         redirectURL: String? = nil) {
        self.signInMethod = signInMethod
        self.action = action
        self.deliveryMedium = deliveryMedium
        self.redirectURL = redirectURL
    }

    func toDictionary() -> [String: String] {
        var dictionary = [
            namespace + ".signInMethod": signInMethod.rawValue,
            namespace + ".action": action.rawValue
        ]
        if let deliveryMedium = deliveryMedium {
            dictionary[namespace + ".deliveryMedium"] = deliveryMedium.rawValue
        }
        if let redirectURL = redirectURL {
            dictionary[namespace + ".redirectUri"] = redirectURL
        }
        return dictionary
    }
}