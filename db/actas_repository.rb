require_relative './mongo'

module ActasRepository
  extend self

  def save(acta)
    DB.actas.update_one(
      { id: acta[:id] },
      { "$set" => acta },
      upsert: true
    )
  end

  def find(id)
    DB.actas.find(id: id).first
  end

  module_function

  def all
    DB.actas.find.to_a
  end
  def stats_by_region
    DB.actas.aggregate([
        { "$group" => {
            _id: "$region",
            votos_validos: { "$sum" => "$votos_validos" },
            votos_nulos:  { "$sum" => "$votos_nulos" },
            total_actas:  { "$sum": 1 }
        }}
    ]).to_a
  end
end
