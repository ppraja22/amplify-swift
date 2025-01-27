//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//


import XCTest
@testable import AWSAPIPlugin

class AppSyncRealTimeRequestAuthTests: XCTestCase {
    let host = UUID().uuidString
    let apiKey = UUID().uuidString
    let date = UUID().uuidString
    let id = UUID().uuidString
    let data = UUID().uuidString
    let token = UUID().uuidString

    var jsonEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        return encoder
    }()

    func testAppSyncRealTimeRequestAuth_encodeCognito() {
        let cognitoAuth = AppSyncRealTimeRequestAuth.AuthToken(host: host, authToken: token)
        XCTAssertEqual(toJson(cognitoAuth)?.shrink(), """
        {
            "Authorization": "\(token)",
            "host": "\(host)"
        }
        """.shrink())
    }

    func testAppSyncRealTimeRequestAuth_encodeApiKey() {
        let apiKeyAuth = AppSyncRealTimeRequestAuth.ApiKey(host: host, apiKey: apiKey, amzDate: date)
        XCTAssertEqual(toJson(apiKeyAuth)?.shrink(), """
        {
            "host": "\(host)",
            "x-amz-date": "\(date)",
            "x-api-key": "\(apiKey)"
        }
        """.shrink())
    }

    func testAppSyncRealTimeRequestAuth_encodeIAM() {
        let securityToken = UUID().uuidString
        let iamAuth = AppSyncRealTimeRequestAuth.IAM(
            host: host,
            authToken: token,
            securityToken: securityToken,
            amzDate: date
        )

        XCTAssertEqual(toJson(iamAuth)?.shrink(), """
        {
            "accept": "application\\/json, text\\/javascript",
            "Authorization": "\(token)",
            "content-encoding": "amz-1.0",
            "content-type": "application\\/json; charset=UTF-8",
            "host": "\(host)",
            "x-amz-date": "\(date)",
            "X-Amz-Security-Token": "\(securityToken)"
        }
        """.shrink())
    }

    func testAppSyncRealTimeRequestAuth_encodeStartRequestWithCognitoAuth() {
        let auth: AppSyncRealTimeRequestAuth = .authToken(.init(host: host, authToken: token))
        let request = AppSyncRealTimeRequest.start(
            .init(id: id, data: data, auth: auth)
        )
        let requestJson = toJson(request)
        XCTAssertEqual(requestJson?.shrink(), """
        {
            "id": "\(id)",
            "payload": {
                "data": "\(data)",
                "extensions": {
                    "authorization": {
                        "Authorization": "\(token)",
                        "host": "\(host)"
                    }
                }
            },
            "type": "start"
        }
        """.shrink())
    }

    func testAppSyncRealTimeRequestAuth_encodeStartRequestWithApiKeyAuth() {
        let auth: AppSyncRealTimeRequestAuth = .apiKey(.init(host: host, apiKey: apiKey, amzDate: date))
        let request = AppSyncRealTimeRequest.start(
            .init(id: id, data: data, auth: auth)
        )
        let requestJson = toJson(request)
        XCTAssertEqual(requestJson?.shrink(), """
        {
            "id": "\(id)",
            "payload": {
                "data": "\(data)",
                "extensions": {
                    "authorization": {
                        "host": "\(host)",
                        "x-amz-date": "\(date)",
                        "x-api-key": "\(apiKey)"
                    }
                }
            },
            "type": "start"
        }
        """.shrink())
    }

    func testAppSyncRealTimeRequestAuth_encodeStartRequestWithIAMAuth() {
        let securityToken = UUID().uuidString
        let iamAuth = AppSyncRealTimeRequestAuth.IAM(
            host: host,
            authToken: token,
            securityToken: securityToken,
            amzDate: date
        )
        let request = AppSyncRealTimeRequest.start(
            .init(id: id, data: data, auth: .iam(iamAuth))
        )
        let requestJson = toJson(request)
        XCTAssertEqual(requestJson?.shrink(), """
        {
            "id": "\(id)",
            "payload": {
                "data": "\(data)",
                "extensions": {
                    "authorization": {
                        "accept": "application\\/json, text\\/javascript",
                        "Authorization": "\(token)",
                        "content-encoding": "amz-1.0",
                        "content-type": "application\\/json; charset=UTF-8",
                        "host": "\(host)",
                        "x-amz-date": "\(date)",
                        "X-Amz-Security-Token": "\(securityToken)"
                    }
                }
            },
            "type": "start"
        }
        """.shrink())
    }

    private func toJson(_ value: Encodable) -> String? {
        return try? String(data: jsonEncoder.encode(value), encoding: .utf8)
    }
}

fileprivate extension String {
    func shrink() -> String {
        return self.replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: " ", with: "")
    }
}
