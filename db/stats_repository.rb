require_relative './mongo'

module StatsRepository
  extend self

  def update_stats(acta)
    DB.stats_region.update_one(
      { departamento: acta[:departamento] },
      {
        "$inc" => {
          total_mesas: 1,
          total_votos: acta[:votos].to_i
        },
        "$set" => {
          ultima_actualizacion: Time.now
        }
      },
      upsert: true
    )
  end

  def get_stats(departamento)
    DB.stats_region.find(departamento: departamento).first
  end

  def global
    DB.stats_region.find.to_a
  end
end
