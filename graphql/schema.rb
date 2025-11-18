require 'graphql'
require_relative './query_type'

class PublicatorSchema < GraphQL::Schema
  query QueryType
end
