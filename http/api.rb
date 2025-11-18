require 'sinatra'
require 'sinatra/json'
require_relative '../db/actas_repository'
require_relative '../swagger/swagger_root'
require_relative '../swagger/swagger_actas'
require 'swagger/blocks'

class Api < Sinatra::Base
  helpers Sinatra::JSON

  set :bind, '0.0.0.0'
  set :port, 4001

  use Rack::Cors do
    allow do
      origins '*'
      resource '*', headers: :any, methods: [:get, :post]
    end
  end

  # ---------------------------
  #        ENDPOINTS
  # ---------------------------

  get "/health" do
    json status: "ok", service: "publicator"
  end

  get "/actas" do
    json ActasRepository.all
  end

  get "/actas/:id" do
    acta = ActasRepository.find(params[:id])
    halt 404, json(error: "No existe el acta #{params[:id]}") unless acta
    json acta
  end

  post "/actas" do
    payload = JSON.parse(request.body.read)
    ActasRepository.save(payload)
    status 201
    json payload
  end

  get "/stats/regions" do
    stats = ActasRepository.stats_by_region
    json stats
  end

  # ---------------------------
  #      SWAGGER ENDPOINTS
  # ---------------------------

  get "/swagger.json" do
    content_type 'application/json'
    Swagger::Blocks.build_root_json([SwaggerRoot, SwaggerActas]).to_json
  end

  get "/docs" do
    <<-HTML
    <!DOCTYPE html>
    <html>
    <head>
      <title>Publicator API Docs</title>
      <link rel="stylesheet" href="https://unpkg.com/swagger-ui-dist/swagger-ui.css" />
    </head>
    <body>
      <div id="swagger-ui"></div>
      <script src="https://unpkg.com/swagger-ui-dist/swagger-ui-bundle.js"></script>
      <script>
        SwaggerUIBundle({
          url: "/swagger.json",
          dom_id: "#swagger-ui"
        });
      </script>
    </body>
    </html>
    HTML
  end
end
