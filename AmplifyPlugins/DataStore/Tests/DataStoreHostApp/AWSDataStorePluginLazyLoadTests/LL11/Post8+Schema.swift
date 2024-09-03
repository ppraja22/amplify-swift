//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

// swiftlint:disable all
import Amplify
import Foundation

public extension Post8 {
  // MARK: - CodingKeys
   enum CodingKeys: String, ModelKey
  {
    case postId
    case title
    case comments
    case createdAt
    case updatedAt
  }

  static let keys = CodingKeys.self
  //  MARK: - ModelSchema

  static let schema = defineSchema { model in
    let post8 = Post8.keys

    model.pluralName = "Post8s"

    model.attributes(
      .index(fields: ["postId", "title"], name: nil),
      .primaryKey(fields: [post8.postId, post8.title])
    )

    model.fields(
      .field(post8.postId, is: .required, ofType: .string),
      .field(post8.title, is: .required, ofType: .string),
      .hasMany(post8.comments, is: .optional, ofType: Comment8.self, associatedFields: [Comment8.keys.postId, Comment8.keys.postTitle]),
      .field(post8.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(post8.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }

    class Path: ModelPath<Post8> { }

    static var rootPath: PropertyContainerPath? { Path() }
}

extension Post8: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Custom
  public typealias IdentifierProtocol = ModelIdentifier<Self, ModelIdentifierFormat.Custom>
}

public extension Post8.IdentifierProtocol {
  static func identifier(postId: String,
      title: String) -> Self
  {
    .make(fields: [(name: "postId", value: postId), (name: "title", value: title)])
  }
}

extension ModelPath where ModelType == Post8 {
    var postId: FieldPath<String> { string("postId") }
    var title: FieldPath<String> { string("title") }
    var comments: ModelPath<Comment8> { Comment8.Path(name: "comments", isCollection: true, parent: self) }
    var createdAt: FieldPath<Temporal.DateTime> { datetime("createdAt") }
    var updatedAt: FieldPath<Temporal.DateTime> { datetime("updatedAt") }
}
