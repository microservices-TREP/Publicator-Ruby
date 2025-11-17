require 'grpc'
require_relative '../proto/actas_services_pb'
require_relative '../publicator_service'

puts "📡 Iniciando Publicator gRPC..."
puts "📡 Publicator gRPC escuchando en puerto 50052"

begin
  grpc_server = GRPC::RpcServer.new
  grpc_server.add_http2_port('0.0.0.0:50052', :this_port_is_insecure)
  grpc_server.handle(PublicatorService)
  puts "✅ Servidor gRPC iniciado correctamente"
  grpc_server.run_till_terminated
rescue => e
  puts "❌ ERROR al iniciar servidor: #{e.message}"
  puts e.backtrace
  exit 1
end
