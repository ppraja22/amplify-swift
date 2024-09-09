//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
@testable import AWSCognitoAuthPlugin


extension SignInState: Codable {

    enum CodingKeys: String, CodingKey {
        case type
        case SignInChallengeState
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        let type = try values.decode(String.self, forKey: .type)
        if type == "SignInState.ResolvingChallenge" {
            self = try .resolvingChallenge(
                values.decode(SignInChallengeState.self, forKey: .SignInChallengeState),
                .smsMfa,
                .apiBased(.userSRP)
            )
        } else {
            fatalError("Decoding not supported")
        }
    }

    public func encode(to encoder: Encoder) throws {

    }
}
