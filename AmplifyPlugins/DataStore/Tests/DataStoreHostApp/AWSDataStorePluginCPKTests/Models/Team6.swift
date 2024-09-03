//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

// swiftlint:disable all
import Amplify
import Foundation

public struct Team6: Model {
  public let teamId: String
  public let name: String
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?

  public init(teamId: String,
      name: String)
  {
    self.init(teamId: teamId,
      name: name,
      createdAt: nil,
      updatedAt: nil)
  }
  init(teamId: String,
      name: String,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil)
  {
      self.teamId = teamId
      self.name = name
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}
