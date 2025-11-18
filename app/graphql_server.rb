require 'sinatra'
require 'graphql'
require "rack/cors"
require_relative '../graphql/schema'

class GraphQLServer < Sinatra::Base
  set :bind, '0.0.0.0'
  set :port, 4000

  use Rack::Cors do
    allow do
      origins '*'
      resource '*', headers: :any, methods: [:post, :get, :options]
    end
  end

  post "/graphql" do
    payload = JSON.parse(request.body.read)

    result = PublicatorSchema.execute(
        payload["query"],
        variables: payload["variables"],
        context: {}
    )

    content_type :json
    result.to_json
  end

  get "/playground" do
    content_type 'text/html'
    File.read(File.join(settings.public_folder, "graphql_playground.html"))
  end
end
