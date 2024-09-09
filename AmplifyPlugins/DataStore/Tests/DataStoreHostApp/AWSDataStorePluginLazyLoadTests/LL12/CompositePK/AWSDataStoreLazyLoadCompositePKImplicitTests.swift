//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Combine
import Foundation
import XCTest

import AWSPluginsCore
@testable import Amplify

extension AWSDataStoreLazyLoadCompositePKTests {

    // MARK: - CompositePKParent / ImplicitChild

    func initImplicitChild(with parent: CompositePKParent) -> ImplicitChild {
        ImplicitChild(childId: UUID().uuidString, content: UUID().uuidString, parent: parent)
    }

    func testSaveImplicitChild() async throws {
        await setup(withModels: CompositePKModels())

        let parent = initParent()
        let savedParent = try await createAndWaitForSync(parent)
        let child = initImplicitChild(with: savedParent)
        try await createAndWaitForSync(child)
    }

    func testUpdateImplicitChild() async throws {
        await setup(withModels: CompositePKModels())
        let parent = initParent()
        let savedParent = try await createAndWaitForSync(parent)
        let child = initImplicitChild(with: parent)
        var savedChild = try await createAndWaitForSync(child)
        let loadedParent = try await savedChild.parent
        XCTAssertEqual(loadedParent.identifier, savedParent.identifier)

        // update the child to a new parent
        let newParent = initParent()
        let savedNewParent = try await createAndWaitForSync(newParent)
        savedChild.setParent(savedNewParent)
        let updatedChild = try await updateAndWaitForSync(savedChild)
        let loadedNewParent = try await updatedChild.parent
        XCTAssertEqual(loadedNewParent.identifier, savedNewParent.identifier)

    }

    func testDeleteImplicitChild() async throws {
        await setup(withModels: CompositePKModels())
        let parent = initParent()
        let savedParent = try await createAndWaitForSync(parent)
        let child = initImplicitChild(with: parent)
        let savedChild = try await createAndWaitForSync(child)

        try await deleteAndWaitForSync(savedChild)
        try await assertModelDoesNotExist(savedChild)
        try await deleteAndWaitForSync(savedParent)
        try await assertModelDoesNotExist(savedParent)
    }

    func testGetImplicitChild() async throws {
        await setup(withModels: CompositePKModels())
        let parent = initParent()
        let savedParent = try await createAndWaitForSync(parent)
        let child = initImplicitChild(with: parent)
        let savedChild = try await createAndWaitForSync(child)

        // query parent and load the children
        let queriedParent = try await query(for: savedParent)

        assertList(queriedParent.implicitChildren!, state: .isNotLoaded(
            associatedIds: [queriedParent.identifier],
            associatedFields: ["parent"]
        ))
        try await queriedParent.implicitChildren?.fetch()
        assertList(queriedParent.implicitChildren!, state: .isLoaded(count: 1))


        // query child and load the parent - ImplicitChild
        let queriedImplicitChild = try await query(for: savedChild)
        assertLazyReference(
            queriedImplicitChild._parent,
            state: .notLoaded(identifiers: [
                .init(name: CompositePKParent.keys.customId.stringValue, value: savedParent.customId),
                .init(name: CompositePKParent.keys.content.stringValue, value: savedParent.content)
            ])
        )
        let loadedParent = try await queriedImplicitChild.parent
        assertLazyReference(
            queriedImplicitChild._parent,
            state: .loaded(model: loadedParent)
        )
    }
}
