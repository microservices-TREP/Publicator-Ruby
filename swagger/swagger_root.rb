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
    key :required, [:id, :mesa]
    property :id do
      key :type, :string
      key :example, "ACTA_001"
    end
    property :mesa do
      key :type, :string
      key :example, "MESA_123"
    end
    property :region do
      key :type, :string
      key :example, "LA PAZ"
    end
    property :votos_validos do
      key :type, :integer
      key :example, 200
    end
    property :votos_nulos do
      key :type, :integer
      key :example, 5
    end
  end
end
