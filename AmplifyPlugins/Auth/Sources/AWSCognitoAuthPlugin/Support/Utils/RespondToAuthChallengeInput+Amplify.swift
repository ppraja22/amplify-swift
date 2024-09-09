//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import AWSCognitoIdentityProvider
import Foundation

extension RespondToAuthChallengeInput {

    // swiftlint:disable:next function_parameter_count
    static func passwordVerifier(
        username: String,
        stateData: SRPStateData,
        session: String?,
        secretBlock: String,
        signature: String,
        clientMetadata: ClientMetadata,
        deviceMetadata: DeviceMetadata,
        asfDeviceId: String?,
        environment: UserPoolEnvironment
    ) async -> RespondToAuthChallengeInput {
        let dateStr = stateData.clientTimestamp.utcString
        let challengeResponses = [
            "USERNAME": username,
            "TIMESTAMP": dateStr,
            "PASSWORD_CLAIM_SECRET_BLOCK": secretBlock,
            "PASSWORD_CLAIM_SIGNATURE": signature
        ]
        return await buildInput(
            username: username,
            challengeType: .passwordVerifier,
            challengeResponses: challengeResponses,
            session: session,
            clientMetadata: clientMetadata,
            asfDeviceId: asfDeviceId,
            deviceMetadata: deviceMetadata,
            environment: environment
        )
    }

    // swiftlint:disable:next function_parameter_count
    static func deviceSRP(
        username: String,
        environment: UserPoolEnvironment,
        deviceMetadata: DeviceMetadata,
        asfDeviceId: String?,
        session: String?,
        publicHexValue: String
    ) async -> RespondToAuthChallengeInput {
        let challengeResponses = [
            "USERNAME": username,
            "SRP_A": publicHexValue
        ]
        return await buildInput(
            username: username,
            challengeType: .deviceSrpAuth,
            challengeResponses: challengeResponses,
            session: session,
            clientMetadata: [:],
            asfDeviceId: asfDeviceId,
            deviceMetadata: deviceMetadata,
            environment: environment
        )
    }

    static func devicePasswordVerifier(
        username: String,
        stateData: SRPStateData,
        session: String?,
        secretBlock: String,
        signature: String,
        deviceMetadata: DeviceMetadata,
        asfDeviceId: String?,
        environment: UserPoolEnvironment
    ) async
    -> RespondToAuthChallengeInput {
        let dateStr = stateData.clientTimestamp.utcString
        let challengeResponses = [
            "USERNAME": username,
            "TIMESTAMP": dateStr,
            "PASSWORD_CLAIM_SECRET_BLOCK": secretBlock,
            "PASSWORD_CLAIM_SIGNATURE": signature
        ]
        return await buildInput(
            username: username,
            challengeType: .devicePasswordVerifier,
            challengeResponses: challengeResponses,
            session: session,
            clientMetadata: [:],
            asfDeviceId: asfDeviceId,
            deviceMetadata: deviceMetadata,
            environment: environment
        )
    }

    // swiftlint:disable:next function_parameter_count
    static func verifyChallenge(
        username: String,
        challengeType: CognitoIdentityProviderClientTypes.ChallengeNameType,
        session: String?,
        responseKey: String,
        answer: String,
        clientMetadata: [String: String]?,
        asfDeviceId: String?,
        attributes: [String: String],
        deviceMetadata: DeviceMetadata,
        environment: UserPoolEnvironment
    ) async -> RespondToAuthChallengeInput {

            var challengeResponses = [
                "USERNAME": username,
                responseKey: answer
            ]

            // Add the attributes to the challenge response
            for attribute in attributes {
                challengeResponses[attribute.key] = attribute.value
            }
            return await buildInput(
                username: username,
                challengeType: challengeType,
                challengeResponses: challengeResponses,
                session: session,
                clientMetadata: clientMetadata ?? [:],
                asfDeviceId: asfDeviceId,
                deviceMetadata: deviceMetadata,
                environment: environment
            )
        }

    static func buildInput(
        username: String,
        challengeType: CognitoIdentityProviderClientTypes.ChallengeNameType,
        challengeResponses: [String: String],
        session: String?,
        clientMetadata: ClientMetadata,
        asfDeviceId: String?,
        deviceMetadata: DeviceMetadata,
        environment: UserPoolEnvironment
    ) async -> RespondToAuthChallengeInput {
            var challengeResponses = challengeResponses
            let userPoolClientId = environment.userPoolConfiguration.clientId
            if let clientSecret = environment.userPoolConfiguration.clientSecret {

                let clientSecretHash = ClientSecretHelper.clientSecretHash(
                    username: username,
                    userPoolClientId: userPoolClientId,
                    clientSecret: clientSecret
                )
                challengeResponses["SECRET_HASH"] = clientSecretHash
            }

            if case .metadata(let data) = deviceMetadata {
                challengeResponses["DEVICE_KEY"] = data.deviceKey
            }

            var userContextData: CognitoIdentityProviderClientTypes.UserContextDataType?
            if let asfDeviceId,
               let encodedData = await CognitoUserPoolASF.encodedContext(
                   username: username,
                   asfDeviceId: asfDeviceId,
                   asfClient: environment.cognitoUserPoolASFFactory(),
                   userPoolConfiguration: environment.userPoolConfiguration
               ) {
                userContextData = .init(encodedData: encodedData)
            }

            let analyticsMetadata = environment
                .cognitoUserPoolAnalyticsHandlerFactory()
                .analyticsMetadata()

            return RespondToAuthChallengeInput(
                analyticsMetadata: analyticsMetadata,
                challengeName: challengeType,
                challengeResponses: challengeResponses,
                clientId: userPoolClientId,
                clientMetadata: clientMetadata,
                session: session,
                userContextData: userContextData
            )

        }
}
