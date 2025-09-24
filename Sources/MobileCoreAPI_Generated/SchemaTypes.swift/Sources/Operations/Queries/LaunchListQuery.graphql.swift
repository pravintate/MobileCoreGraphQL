// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class LaunchListQuery: GraphQLQuery {
  public static let operationName: String = "LaunchList"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query LaunchList { launches { __typename hasMore cursor launches { __typename id site } } }"#
    ))

  public init() {}

  public struct Data: MobileCoreAPI_Generated.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MobileCoreAPI_Generated.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("launches", Launches.self),
    ] }

    public var launches: Launches { __data["launches"] }

    /// Launches
    ///
    /// Parent Type: `LaunchConnection`
    public struct Launches: MobileCoreAPI_Generated.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { MobileCoreAPI_Generated.Objects.LaunchConnection }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("hasMore", Bool.self),
        .field("cursor", String.self),
        .field("launches", [Launch?].self),
      ] }

      public var hasMore: Bool { __data["hasMore"] }
      public var cursor: String { __data["cursor"] }
      public var launches: [Launch?] { __data["launches"] }

      /// Launches.Launch
      ///
      /// Parent Type: `Launch`
      public struct Launch: MobileCoreAPI_Generated.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { MobileCoreAPI_Generated.Objects.Launch }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", MobileCoreAPI_Generated.ID.self),
          .field("site", String?.self),
        ] }

        public var id: MobileCoreAPI_Generated.ID { __data["id"] }
        public var site: String? { __data["site"] }
      }
    }
  }
}
