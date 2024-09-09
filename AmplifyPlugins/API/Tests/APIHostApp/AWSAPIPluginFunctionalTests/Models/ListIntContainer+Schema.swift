//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

// swiftlint:disable all
import Amplify
import Foundation

public extension ListIntContainer {
  // MARK: - CodingKeys
   enum CodingKeys: String, ModelKey {
    case id
    case test
    case nullableInt
    case intList
    case intNullableList
    case nullableIntList
    case nullableIntNullableList
    case createdAt
    case updatedAt
  }

  static let keys = CodingKeys.self
  //  MARK: - ModelSchema

  static let schema = defineSchema { model in
    let listIntContainer = ListIntContainer.keys

    model.pluralName = "ListIntContainers"

    model.fields(
      .id(),
      .field(listIntContainer.test, is: .required, ofType: .int),
      .field(listIntContainer.nullableInt, is: .optional, ofType: .int),
      .field(listIntContainer.intList, is: .required, ofType: .embeddedCollection(of: Int.self)),
      .field(listIntContainer.intNullableList, is: .optional, ofType: .embeddedCollection(of: Int.self)),
      .field(listIntContainer.nullableIntList, is: .required, ofType: .embeddedCollection(of: Int.self)),
      .field(listIntContainer.nullableIntNullableList, is: .optional, ofType: .embeddedCollection(of: Int.self)),
      .field(listIntContainer.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(listIntContainer.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}
