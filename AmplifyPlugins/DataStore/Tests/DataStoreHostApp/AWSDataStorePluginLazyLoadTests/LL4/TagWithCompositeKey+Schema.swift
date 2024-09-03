//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

// swiftlint:disable all
import Amplify
import Foundation

public extension TagWithCompositeKey {
  // MARK: - CodingKeys
   enum CodingKeys: String, ModelKey
  {
    case id
    case name
    case posts
    case createdAt
    case updatedAt
  }

  static let keys = CodingKeys.self
  //  MARK: - ModelSchema

  static let schema = defineSchema { model in
    let tagWithCompositeKey = TagWithCompositeKey.keys

    model.pluralName = "TagWithCompositeKeys"

    model.attributes(
      .index(fields: ["id", "name"], name: nil),
      .primaryKey(fields: [tagWithCompositeKey.id, tagWithCompositeKey.name])
    )

    model.fields(
      .field(tagWithCompositeKey.id, is: .required, ofType: .string),
      .field(tagWithCompositeKey.name, is: .required, ofType: .string),
      .hasMany(tagWithCompositeKey.posts, is: .optional, ofType: PostTagsWithCompositeKey.self, associatedWith: PostTagsWithCompositeKey.keys.tagWithCompositeKey),
      .field(tagWithCompositeKey.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(tagWithCompositeKey.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
    class Path: ModelPath<TagWithCompositeKey> { }

    static var rootPath: PropertyContainerPath? { Path() }
}

extension TagWithCompositeKey: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Custom
  public typealias IdentifierProtocol = ModelIdentifier<Self, ModelIdentifierFormat.Custom>
}

public extension TagWithCompositeKey.IdentifierProtocol {
  static func identifier(id: String,
      name: String) -> Self
  {
    .make(fields: [(name: "id", value: id), (name: "name", value: name)])
  }
}
public extension ModelPath where ModelType == TagWithCompositeKey {
  var id: FieldPath<String>   {
      string("id")
    }
  var name: FieldPath<String>   {
      string("name")
    }
  var posts: ModelPath<PostTagsWithCompositeKey>   {
      PostTagsWithCompositeKey.Path(name: "posts", isCollection: true, parent: self)
    }
  var createdAt: FieldPath<Temporal.DateTime>   {
      datetime("createdAt")
    }
  var updatedAt: FieldPath<Temporal.DateTime>   {
      datetime("updatedAt")
    }
}
