//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

// swiftlint:disable all
import Amplify
import Foundation

public extension Post4 {
  // MARK: - CodingKeys
   enum CodingKeys: String, ModelKey
  {
    case id
    case title
    case comments
  }

  static let keys = CodingKeys.self
  //  MARK: - ModelSchema

  static let schema = defineSchema { model in
    let post4 = Post4.keys

    model.listPluralName = "Post4s"
    model.syncPluralName = "Post4s"

    model.fields(
      .id(),
      .field(post4.title, is: .required, ofType: .string),
      .hasMany(post4.comments, is: .optional, ofType: Comment4.self, associatedWith: Comment4.keys.post)
    )
    }
}
