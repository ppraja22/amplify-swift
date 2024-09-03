//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

// swiftlint:disable all
import Amplify
import Foundation

public extension Restaurant {
  // MARK: - CodingKeys
   enum CodingKeys: String, ModelKey
  {
    case id
    case restaurantName
    case menus
  }

  static let keys = CodingKeys.self
  //  MARK: - ModelSchema

  static let schema = defineSchema { model in
    let restaurant = Restaurant.keys

    model.listPluralName = "Restaurants"
    model.syncPluralName = "Restaurants"

    model.fields(
      .id(),
      .field(restaurant.restaurantName, is: .required, ofType: .string),
      .hasMany(restaurant.menus, is: .optional, ofType: Menu.self, associatedWith: Menu.keys.restaurant)
    )
    }
}
