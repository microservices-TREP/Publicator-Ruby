require_relative './mongo'

module ActasRepository
  extend self

  # ---------------------------------------------------------
  # Guarda un acta (si existe una con la misma id, actualiza)
  # ---------------------------------------------------------
  def save(acta)
    DB.actas.update_one(
      { id: acta[:id] },
      { "$set" => acta },
      upsert: true
    )
  end

  # ---------------------------------------------------------
  # Buscar un acta por ID
  # ---------------------------------------------------------
  def find(id)
    DB.actas.find(id: id).sort({ hora_validacion: -1 }).first
  end

  # ---------------------------------------------------------
  # Obtener solo la última acta por cada ID
  # ---------------------------------------------------------
  def all
    DB.actas.aggregate([
      # Ordenamos por hora de validación descendente
      { "$sort" => { hora_validacion: -1 }},

      # Agrupamos por ID, pero solo conservamos la primera (la más nueva)
      { "$group" => {
          _id: "$id",
          acta: { "$first" => "$$ROOT" }
      }},

      # Proyectamos solo el acta
      { "$replaceWith" => "$acta" }
    ]).to_a
  end

  # ---------------------------------------------------------
  # Estadísticas por recinto
  # ---------------------------------------------------------
def stats_by_recinto
  DB.actas.aggregate([
    # Convertimos votos_partidos en un array de pares {k, v}
    { "$addFields" => {
        votos_partidos_array: { "$objectToArray" => "$votos_partidos" }
    }},

    # Expandimos cada partido
    { "$unwind" => "$votos_partidos_array" },

    # Agrupamos por recinto y por partido
    { "$group" => {
        _id: {
          recinto: "$recinto",
          partido: "$votos_partidos_array.k"
        },
        votos_partido: { "$sum" => "$votos_partidos_array.v" },
        votos_validos: { "$sum" => "$votos_validos" },
        votos_invalidos: { "$sum" => "$votos_invalidos" },
        total_actas: { "$sum" => 1 }
    }},

    # Reagrupamos por recinto, consolidando partidos en un subdocumento
    { "$group" => {
        _id: "$_id.recinto",
        votos_validos:   { "$first" => "$votos_validos" },
        votos_invalidos: { "$first" => "$votos_invalidos" },
        total_actas:     { "$first" => "$total_actas" },
        votos_partidos: {
          "$push" => {
            partido: "$_id.partido",
            votos: "$votos_partido"
          }
        }
    }}
  ]).to_a
end

  # ---------------------------------------------------------
  # Estadísticas por municipio
  # ---------------------------------------------------------
def stats_by_municipio
  DB.actas.aggregate([
    { "$addFields" => {
        votos_partidos_array: { "$objectToArray" => "$votos_partidos" }
    }},
    { "$unwind" => "$votos_partidos_array" },

    { "$group" => {
        _id: {
          departamento: "$departamento",
          provincia: "$provincia",
          municipio: "$municipio",
          partido: "$votos_partidos_array.k"
        },
        votos_partido: { "$sum" => "$votos_partidos_array.v" },
        votos_validos: { "$sum" => "$votos_validos" },
        votos_invalidos: { "$sum" => "$votos_invalidos" },
        total_actas: { "$sum" => 1 }
    }},

    { "$group" => {
        _id: {
          departamento: "$_id.departamento",
          provincia: "$_id.provincia",
          municipio: "$_id.municipio"
        },
        votos_validos:   { "$first" => "$votos_validos" },
        votos_invalidos: { "$first" => "$votos_invalidos" },
        total_actas:     { "$first" => "$total_actas" },
        votos_partidos: {
          "$push" => {
            partido: "$_id.partido",
            votos: "$votos_partido"
          }
        }
    }}
  ]).to_a
end


  # ---------------------------------------------------------
  # Estadísticas por provincia
  # ---------------------------------------------------------
def stats_by_provincia
  DB.actas.aggregate([
    { "$addFields" => {
        votos_partidos_array: { "$objectToArray" => "$votos_partidos" }
    }},
    { "$unwind" => "$votos_partidos_array" },

    { "$group" => {
        _id: {
          departamento: "$departamento",
          provincia: "$provincia",
          partido: "$votos_partidos_array.k"
        },
        votos_partido: { "$sum" => "$votos_partidos_array.v" },
        votos_validos: { "$sum" => "$votos_validos" },
        votos_invalidos: { "$sum" => "$votos_invalidos" },
        total_actas: { "$sum" => 1 }
    }},

    { "$group" => {
        _id: {
          departamento: "$_id.departamento",
          provincia: "$_id.provincia"
        },
        votos_validos:   { "$first" => "$votos_validos" },
        votos_invalidos: { "$first" => "$votos_invalidos" },
        total_actas:     { "$first" => "$total_actas" },
        votos_partidos: {
          "$push" => {
            partido: "$_id.partido",
            votos: "$votos_partido"
          }
        }
    }}
  ]).to_a
end


  # ---------------------------------------------------------
  # Estadísticas por departamento
  # ---------------------------------------------------------
def stats_by_departamento
  DB.actas.aggregate([
    { "$addFields" => {
        votos_partidos_array: { "$objectToArray" => "$votos_partidos" }
    }},
    { "$unwind" => "$votos_partidos_array" },

    { "$group" => {
        _id: {
          departamento: "$departamento",
          partido: "$votos_partidos_array.k"
        },
        votos_partido: { "$sum" => "$votos_partidos_array.v" },
        votos_validos: { "$sum" => "$votos_validos" },
        votos_invalidos: { "$sum" => "$votos_invalidos" },
        total_actas: { "$sum" => 1 }
    }},

    { "$group" => {
        _id: "$_id.departamento",
        votos_validos:   { "$first" => "$votos_validos" },
        votos_invalidos: { "$first" => "$votos_invalidos" },
        total_actas:     { "$first" => "$total_actas" },
        votos_partidos: {
          "$push" => {
            partido: "$_id.partido",
            votos: "$votos_partido"
          }
        }
    }}
  ]).to_a
end

  # ---------------------------------------------------------
  # Votos totales por partido
  # ---------------------------------------------------------
def stats_votos_partidos_totales
  DB.actas.aggregate([
    # Convertir mapa → array [{k, v}]
    { "$addFields" => {
        votos_partidos_array: { "$objectToArray" => "$votos_partidos" }
    }},

    # Explode por cada partido
    { "$unwind" => "$votos_partidos_array" },

    # Agrupar por partido
    { "$group" => {
        _id: "$votos_partidos_array.k",
        votos: { "$sum" => "$votos_partidos_array.v" }
    }},

    # Ordenar por votos totales, descendente
    { "$sort" => { votos: -1 }},

    # Renombrar para formato consistente
    { "$project" => {
        partido: "$_id",
        votos: 1,
        _id: 0
    }}
  ]).to_a
end

end
