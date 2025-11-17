require 'sinatra'
require 'json'
require_relative '../db/actas_repository'
require_relative '../db/stats_repository'
require_relative '../app/graphql_schema'

post '/graphql' do
  content_type :json
  request.body.rewind
  payload = JSON.parse(request.body.read)
  result = GraphQLSchema::Schema.execute(payload['query'], variables: payload['variables'])
  result.to_json
end

get "/api/actas/:id" do
  acta = ActasRepository.find(params[:id])
  return { ok: false, message: "No encontrada" }.to_json if acta.nil?
  acta.to_json
end

get "/api/departamentos/:dep/estadisticas" do
  stats = StatsRepository.get_stats(params[:dep])
  return { ok: false, message: "No encontrada" }.to_json if stats.nil?
  stats.to_json
end

get "/api/resultados/globales" do
  StatsRepository.global.to_json
end
