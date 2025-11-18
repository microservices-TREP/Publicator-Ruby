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
end
