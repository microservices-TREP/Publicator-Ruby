require 'grpc'
require_relative '../proto/actas_services_pb'
require_relative '../publicator_service'

require_relative './graphql_server'

Thread.new do
  puts "🚀 Iniciando servidor GraphQL en puerto 4000..."
  GraphQLServer.run!
end

puts "📡 Iniciando Publicator gRPC..."
grpc_server = GRPC::RpcServer.new
grpc_server.add_http2_port('0.0.0.0:50052', :this_port_is_insecure)
grpc_server.handle(PublicatorService)
grpc_server.run_till_terminated