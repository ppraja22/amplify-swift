//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

// swiftlint:disable all
import Amplify
import Foundation

public extension Post18 {
  // MARK: - CodingKeys
   enum CodingKeys: String, ModelKey
  {
    case postId
    case sk
    case createdAt
    case updatedAt
  }

  static let keys = CodingKeys.self
  //  MARK: - ModelSchema

  static let schema = defineSchema { model in
    let post18 = Post18.keys

    model.pluralName = "Post18s"

    model.attributes(
      .index(fields: ["postId", "sk"], name: nil),
      .primaryKey(fields: [post18.postId, post18.sk])
    )

    model.fields(
      .field(post18.postId, is: .required, ofType: .string),
      .field(post18.sk, is: .required, ofType: .string),
      .field(post18.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(post18.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Post18: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Custom
  public typealias IdentifierProtocol = ModelIdentifier<Self, ModelIdentifierFormat.Custom>
}

public extension Post18.IdentifierProtocol {
  static func identifier(postId: String,
      sk: String) -> Self
  {
    .make(fields: [(name: "postId", value: postId), (name: "sk", value: sk)])
  }
}
