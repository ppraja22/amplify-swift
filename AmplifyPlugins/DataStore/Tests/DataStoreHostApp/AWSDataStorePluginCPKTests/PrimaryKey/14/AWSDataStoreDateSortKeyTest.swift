//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

/** Model Schema
type Post14 @model {
  postId: ID! @primaryKey(sortKeyFields: ["sk"])
  sk: AWSDate!
}
*/

import AWSAPIPlugin
import AWSDataStorePlugin
import Combine
import Foundation
import XCTest

@testable import Amplify
#if !os(watchOS)
@testable import DataStoreHostApp
#endif

private struct TestModels: AmplifyModelRegistration {
    func registerModels(registry: ModelRegistry.Type) {
        ModelRegistry.register(modelType: Post14.self)
    }

    var version: String = "test"
}

class AWSDataStoreDateSortKeyTest: XCTestCase {
    let configFile = "testconfiguration/AWSDataStoreCategoryPluginPrimaryKeyIntegrationTests-amplifyconfiguration"

    override func setUp() async throws {
        continueAfterFailure = true
        let config = try TestConfigHelper.retrieveAmplifyConfiguration(forResource: configFile)
        try Amplify.add(plugin: AWSAPIPlugin(
            sessionFactory: AmplifyURLSessionFactory())
        )
        #if os(watchOS)
        try Amplify.add(plugin: AWSDataStorePlugin(
            modelRegistration: TestModels(),
            configuration: .custom(syncMaxRecords: 100, disableSubscriptions: { false })
        ))
        #else
        try Amplify.add(plugin: AWSDataStorePlugin(
            modelRegistration: TestModels(),
            configuration: .custom(syncMaxRecords: 100)
        ))
        #endif
        Amplify.Logging.logLevel = .verbose
        try Amplify.configure(config)
    }

    override func tearDown() async throws {
        try await Amplify.DataStore.clear()
        await Amplify.reset()
        try await Task.sleep(seconds: 1)
    }

    func waitDataStoreReady() async throws {
        let ready = expectation(description: "DataStore is ready")
        var requests: Set<AnyCancellable> = []
        Amplify.Hub.publisher(for: .dataStore)
            .filter { $0.eventName == HubPayload.EventName.DataStore.ready }
            .sink { _ in
                ready.fulfill()
            }
            .store(in: &requests)

        try await Amplify.DataStore.start()
        await fulfillment(of: [ready], timeout: 60)
    }

    func testCreateModel_withSortKeyInAWSDateType_success() async throws {
        try await waitDataStoreReady()
        var requests: Set<AnyCancellable> = []
        let post = Post14(postId: UUID().uuidString, sk: Temporal.Date.now())
        let postCreated = expectation(description: "Post is created")
        postCreated.assertForOverFulfill = false
        Amplify.Hub.publisher(for: .dataStore)
            .filter { $0.eventName == HubPayload.EventName.DataStore.syncReceived }
            .compactMap { $0.data as? MutationEvent }
            .filter { $0.modelId == post.identifier }
            .sink { _ in
                postCreated.fulfill()
            }.store(in: &requests)

        try await Amplify.DataStore.save(post)
        await fulfillment(of: [postCreated], timeout: 5)
    }

    func testQueryCreatedModel_withSortKeyInAWSDateType_success() async throws {
        try await waitDataStoreReady()
        var requests: Set<AnyCancellable> = []
        let post = Post14(postId: UUID().uuidString, sk: Temporal.Date.now())
        let postCreated = expectation(description: "Post is created")
        postCreated.assertForOverFulfill = false
        Amplify.Hub.publisher(for: .dataStore)
            .filter { $0.eventName == HubPayload.EventName.DataStore.syncReceived }
            .compactMap { $0.data as? MutationEvent }
            .filter { $0.modelId == post.identifier }
            .sink { _ in
                postCreated.fulfill()
            }.store(in: &requests)

        try await Amplify.DataStore.save(post)
        await fulfillment(of: [postCreated], timeout: 5)

        let queryResult = try await Amplify.API.query(
            request: .get(
                Post14.self,
                byIdentifier: .identifier(postId: post.postId, sk: post.sk)
            )
        )

        switch queryResult {
        case .success(let queriedPost):
            XCTAssertEqual(post.identifier, queriedPost!.identifier)
        case .failure(let error):
            XCTFail("Failed to query comment \(error)")
        }
    }

}


