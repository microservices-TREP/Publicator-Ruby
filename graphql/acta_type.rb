require 'graphql'

class ActaType < GraphQL::Schema::Object
  field :id, ID, null: true
  field :mesa_id, String, null: true
  field :departamento, String, null: true
  field :provincia, String, null: true
  field :municipio, String, null: true
  field :recinto, String, null: true
  field :votos_partidos, GraphQL::Types::JSON, null: true
  field :votos_validos, Integer, null: true
  field :votos_invalidos, Integer, null: true
  field :hora_validacion, String, null: true
end
