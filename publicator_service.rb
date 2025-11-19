require 'grpc'
require_relative './proto/actas_services_pb'
require_relative './db/mongo'
require_relative './db/actas_repository'
require_relative './db/stats_repository'

class PublicatorService < Trep::PublicatorService::Service
  def publish_acta(acta, _unused)
    puts "📥 Acta recibida por gRPC: #{acta.id}"

    # Mapear campos del mensaje protobuf a la estructura interna
    acta_hash = {
      id: acta.id,
      mesa_id: acta.mesa,                  # campo 'mesa' en protobuf
      votos_validos: acta.votos_validos.to_i,      # campo usado por StatsRepository
      votos_invalidos: acta.votos_invalidos.to_i,
      departamento: acta.departamento,
      provincia: acta.provincia,
      municipio: acta.municipio,
      recinto: acta.recinto,
      partido: acta.respond_to?(:partido) ? acta.partido : nil,
      hora_validacion: Time.now
    }

    # Guardar en BD
    ActasRepository.save(acta_hash)

    # Actualizar estadísticas por región
    StatsRepository.update_stats(acta_hash)

    return Trep::Ack.new(ok: true, message: "Acta procesada")
  rescue => e
    puts "❌ ERROR Publicator: #{e.message}"
    return Trep::Ack.new(ok: false, message: e.message)
  end
end
