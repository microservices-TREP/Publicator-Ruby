require_relative '../db/actas_repository'
require_relative '../db/stats_repository'

module GraphQLSchema
  class ActaType < GraphQL::Schema::Object
    field :id, String, null: false
    field :mesa, String, null: true
    field :votos_validos, Integer, null: true
    field :departamento, String, null: true
    field :recinto, String, null: true
  end

  class StatsType < GraphQL::Schema::Object
    field :departamento, String, null: true
    field :total_mesas, Integer, null: true
    field :total_votos, Integer, null: true
    field :ultima_actualizacion, String, null: true
  end

  class QueryType < GraphQL::Schema::Object
    field :acta, ActaType, null: true do
      argument :id, String, required: true
    end

    def acta(id:)
      doc = ActasRepository.find(id)
      return nil if doc.nil?
      {
        id: doc['id'],
        mesa: doc['mesa_id'] || doc['mesa'],
        votos_validos: doc['votos'],
        departamento: doc['departamento'],
        recinto: doc['recinto']
      }
    end

    field :stats, StatsType, null: true do
      argument :departamento, String, required: true
    end

    def stats(departamento:)
      stat = StatsRepository.get_stats(departamento)
      return nil if stat.nil?
      stat
    end

    field :global_results, [StatsType], null: true
    def global_results
      StatsRepository.global
    end
  end

  class Schema < GraphQL::Schema
    query QueryType
  end
end
