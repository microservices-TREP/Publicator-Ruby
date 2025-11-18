require 'graphql'

class ActaType < GraphQL::Schema::Object
  field :id, ID, null: true
  field :region, String, null: true
  field :mesa, String, null: true
  field :votos_validos, Integer, null: true
  field :votos_blancos, Integer, null: true
  field :votos_nulos, Integer, null: true
end
