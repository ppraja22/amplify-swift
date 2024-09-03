//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

// swiftlint:disable all
import Amplify
import Foundation

public struct PhoneCall: Model {
  public let id: String
  var _caller: LazyReference<Person>
  public var caller: Person   {
      get async throws {
        try await _caller.require()
      }
    }
  var _callee: LazyReference<Person>
  public var callee: Person   {
      get async throws {
        try await _callee.require()
      }
    }
  var _transcript: LazyReference<Transcript>
  public var transcript: Transcript?   {
      get async throws {
        try await _transcript.get()
      }
    }
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  public var phoneCallTranscriptId: String?

  public init(id: String = UUID().uuidString,
      caller: Person,
      callee: Person,
      transcript: Transcript? = nil,
      phoneCallTranscriptId: String? = nil)
  {
    self.init(id: id,
      caller: caller,
      callee: callee,
      transcript: transcript,
      createdAt: nil,
      updatedAt: nil,
      phoneCallTranscriptId: phoneCallTranscriptId)
  }
  init(id: String = UUID().uuidString,
      caller: Person,
      callee: Person,
      transcript: Transcript? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil,
      phoneCallTranscriptId: String? = nil)
  {
      self.id = id
      self._caller = LazyReference(caller)
      self._callee = LazyReference(callee)
      self._transcript = LazyReference(transcript)
      self.createdAt = createdAt
      self.updatedAt = updatedAt
      self.phoneCallTranscriptId = phoneCallTranscriptId
  }
  public mutating func setCaller(_ caller: Person) {
    _caller = LazyReference(caller)
  }
  public mutating func setCallee(_ callee: Person) {
    _callee = LazyReference(callee)
  }
  public mutating func setTranscript(_ transcript: Transcript? = nil) {
    _transcript = LazyReference(transcript)
  }
  public init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      self.id = try values.decode(String.self, forKey: .id)
      self._caller = try values.decodeIfPresent(LazyReference<Person>.self, forKey: .caller) ?? LazyReference(identifiers: nil)
      self._callee = try values.decodeIfPresent(LazyReference<Person>.self, forKey: .callee) ?? LazyReference(identifiers: nil)
      self._transcript = try values.decodeIfPresent(LazyReference<Transcript>.self, forKey: .transcript) ?? LazyReference(identifiers: nil)
      self.createdAt = try? values.decode(Temporal.DateTime?.self, forKey: .createdAt)
      self.updatedAt = try? values.decode(Temporal.DateTime?.self, forKey: .updatedAt)
      self.phoneCallTranscriptId = try? values.decode(String?.self, forKey: .phoneCallTranscriptId)
  }
  public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(id, forKey: .id)
      try container.encode(_caller, forKey: .caller)
      try container.encode(_callee, forKey: .callee)
      try container.encode(_transcript, forKey: .transcript)
      try container.encode(createdAt, forKey: .createdAt)
      try container.encode(updatedAt, forKey: .updatedAt)
      try container.encode(phoneCallTranscriptId, forKey: .phoneCallTranscriptId)
  }
}
