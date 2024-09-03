//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

// swiftlint:disable all
import Amplify
import Foundation

public extension Post15 {
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
    let post15 = Post15.keys

    model.pluralName = "Post15s"

    model.attributes(
      .index(fields: ["postId", "sk"], name: nil),
      .primaryKey(fields: [post15.postId, post15.sk])
    )

    model.fields(
      .field(post15.postId, is: .required, ofType: .string),
      .field(post15.sk, is: .required, ofType: .time),
      .field(post15.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(post15.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Post15: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Custom
  public typealias IdentifierProtocol = ModelIdentifier<Self, ModelIdentifierFormat.Custom>
}

public extension Post15.IdentifierProtocol {
  static func identifier(postId: String,
      sk: Temporal.Time) -> Self
  {
    .make(fields: [(name: "postId", value: postId), (name: "sk", value: sk)])
  }
}
