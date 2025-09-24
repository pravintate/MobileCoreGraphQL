// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import MobileCoreAPI_Generated

public class TripBookedSubscription: GraphQLSubscription {
  public static let operationName: String = "TripBooked"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"subscription TripBooked { tripsBooked }"#
    ))

  public init() {}

  public struct Data: MobileCoreAPI_Generated.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MobileCoreAPI_Generated.Objects.Subscription }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("tripsBooked", Int?.self),
    ] }

    public var tripsBooked: Int? { __data["tripsBooked"] }
  }
}
