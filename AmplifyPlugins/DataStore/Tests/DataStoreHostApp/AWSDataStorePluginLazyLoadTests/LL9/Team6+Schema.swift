//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

// swiftlint:disable all
import Amplify
import Foundation

public extension Team6 {
  // MARK: - CodingKeys
   enum CodingKeys: String, ModelKey {
    case teamId
    case name
    case createdAt
    case updatedAt
  }

  static let keys = CodingKeys.self
  //  MARK: - ModelSchema

  static let schema = defineSchema { model in
    let team6 = Team6.keys

    model.pluralName = "Team6s"

    model.attributes(
      .index(fields: ["teamId", "name"], name: nil),
      .primaryKey(fields: [team6.teamId, team6.name])
    )

    model.fields(
      .field(team6.teamId, is: .required, ofType: .string),
      .field(team6.name, is: .required, ofType: .string),
      .field(team6.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(team6.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }

    class Path: ModelPath<Team6> { }

    static var rootPath: PropertyContainerPath? { Path() }
}

extension Team6: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Custom
  public typealias IdentifierProtocol = ModelIdentifier<Self, ModelIdentifierFormat.Custom>
}

public extension Team6.IdentifierProtocol {
  static func identifier(
    teamId: String,
    name: String
  ) -> Self {
    .make(fields: [(name: "teamId", value: teamId), (name: "name", value: name)])
  }
}

extension ModelPath where ModelType == Team6 {
    var teamId: FieldPath<String> { string("projectId") }
    var name: FieldPath<String> { string("name") }
    var createdAt: FieldPath<Temporal.DateTime> { datetime("createdAt") }
    var updatedAt: FieldPath<Temporal.DateTime> { datetime("updatedAt") }
}
