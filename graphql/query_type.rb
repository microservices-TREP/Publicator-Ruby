require 'graphql'
require_relative '../db/actas_repository'
require_relative './acta_type'

class QueryType < GraphQL::Schema::Object
  description "Consultas disponibles en el Publicator"

  field :actas, [ActaType], null: false do
    description "Lista todas las actas publicadas"
  end

  def actas
    ActasRepository.all
  end
end
