// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class LoginMutation: GraphQLMutation {
  public static let operationName: String = "Login"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation Login($email: String!) { login(email: $email) { __typename token } }"#
    ))

  public var email: String

  public init(email: String) {
    self.email = email
  }

  public var __variables: Variables? { ["email": email] }

  public struct Data: MobileCoreAPI_Generated.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MobileCoreAPI_Generated.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("login", Login?.self, arguments: ["email": .variable("email")]),
    ] }

    public var login: Login? { __data["login"] }

    /// Login
    ///
    /// Parent Type: `User`
    public struct Login: MobileCoreAPI_Generated.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { MobileCoreAPI_Generated.Objects.User }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("token", String?.self),
      ] }

      public var token: String? { __data["token"] }
    }
  }
}
