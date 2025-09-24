// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public protocol SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == MobileCoreAPI_Generated.SchemaMetadata {}

public protocol InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == MobileCoreAPI_Generated.SchemaMetadata {}

public protocol MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == MobileCoreAPI_Generated.SchemaMetadata {}

public protocol MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == MobileCoreAPI_Generated.SchemaMetadata {}

public enum SchemaMetadata: ApolloAPI.SchemaMetadata {
  public static let configuration: any ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

  public static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
    switch typename {
    case "Launch": return MobileCoreAPI_Generated.Objects.Launch
    case "LaunchConnection": return MobileCoreAPI_Generated.Objects.LaunchConnection
    case "Mutation": return MobileCoreAPI_Generated.Objects.Mutation
    case "Query": return MobileCoreAPI_Generated.Objects.Query
    case "Subscription": return MobileCoreAPI_Generated.Objects.Subscription
    case "TripUpdateResponse": return MobileCoreAPI_Generated.Objects.TripUpdateResponse
    case "User": return MobileCoreAPI_Generated.Objects.User
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}
