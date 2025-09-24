// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import MobileCoreAPI_Generated

public class BookTripMutation: GraphQLMutation {
  public static let operationName: String = "BookTrip"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation BookTrip($ids: [ID]!) { bookTrips(launchIds: $ids) { __typename message } }"#
    ))

  public var ids: [MobileCoreAPI_Generated.ID?]

  public init(ids: [MobileCoreAPI_Generated.ID?]) {
    self.ids = ids
  }

  public var __variables: Variables? { ["ids": ids] }

  public struct Data: MobileCoreAPI_Generated.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MobileCoreAPI_Generated.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("bookTrips", BookTrips.self, arguments: ["launchIds": .variable("ids")]),
    ] }

    public var bookTrips: BookTrips { __data["bookTrips"] }

    /// BookTrips
    ///
    /// Parent Type: `TripUpdateResponse`
    public struct BookTrips: MobileCoreAPI_Generated.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { MobileCoreAPI_Generated.Objects.TripUpdateResponse }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("message", String?.self),
      ] }

      public var message: String? { __data["message"] }
    }
  }
}
