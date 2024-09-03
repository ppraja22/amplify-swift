//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

// swiftlint:disable all
import Amplify
import Foundation

public extension Comment9 {
  // MARK: - CodingKeys
   enum CodingKeys: String, ModelKey
  {
    case commentId
    case postId
    case content
    case createdAt
    case updatedAt
  }

  static let keys = CodingKeys.self
  //  MARK: - ModelSchema

  static let schema = defineSchema { model in
    let comment9 = Comment9.keys

    model.pluralName = "Comment9s"

    model.attributes(
      .index(fields: ["commentId", "postId"], name: nil),
      .index(fields: ["postId"], name: "byPost9"),
      .primaryKey(fields: [comment9.commentId, comment9.postId])
    )

    model.fields(
      .field(comment9.commentId, is: .required, ofType: .string),
      .field(comment9.postId, is: .required, ofType: .string),
      .field(comment9.content, is: .optional, ofType: .string),
      .field(comment9.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(comment9.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Comment9: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Custom
  public typealias IdentifierProtocol = ModelIdentifier<Self, ModelIdentifierFormat.Custom>
}

public extension Comment9.IdentifierProtocol {
  static func identifier(commentId: String,
      postId: String) -> Self
  {
    .make(fields: [(name: "commentId", value: commentId), (name: "postId", value: postId)])
  }
}
