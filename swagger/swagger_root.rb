require 'swagger/blocks'

class SwaggerRoot
  include Swagger::Blocks

  swagger_root do
    key :openapi, '3.0.0'
    info do
      key :version, '1.0.0'
      key :title, 'Publicator API'
      key :description, 'API REST para consultar actas publicadas y estadísticas'
    end

    server do
      key :url, 'http://localhost:4000'
      key :description, 'Servidor de desarrollo'
    end
  end

  swagger_schema :Acta do
    property :id do
      key :type, :string
    end
    property :mesa_id do
      key :type, :string
    end
    property :departamento do
      key :type, :string
    end
    property :provincia do
      key :type, :string
    end
    property :municipio do
      key :type, :string
    end
    property :recinto do
      key :type, :string
    end
    property :votos_validos do
      key :type, :integer
    end
    property :votos_invalidos do
      key :type, :integer
    end

    # Nuevo objeto: votos_partidos
    property :votos_partidos do
      key :type, :object
      key :properties, {}   # obligatorio para swagger-blocks <3.1
      key "x-additionalProperties", { type: :integer }
      key :example, {
        "partido_A": 70,
        "partido_B": 55
      }
    end

    property :hora_validacion do
      key :type, :string
      key :format, :date_time
    end
  end
end
