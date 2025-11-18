require 'swagger/blocks'

class SwaggerActas
  include Swagger::Blocks

  swagger_path '/actas' do
    operation :get do
      key :summary, 'Lista todas las actas'
      key :tags, ['Actas']

      response 200 do
        key :description, 'Lista de actas'
        content 'application/json' do
          schema type: :array do
            items do
              key :'$ref', :Acta
            end
          end
        end
      end
    end

    operation :post do
      key :summary, 'Crea un acta manualmente'
      key :tags, ['Actas']

      request_body do
        content 'application/json' do
          schema do
            key :'$ref', :Acta
          end
        end
      end

      response 201 do
        key :description, 'Acta creada'
      end
    end
  end

  swagger_path '/actas/{id}' do
    operation :get do
      key :summary, 'Busca una acta por ID'
      key :tags, ['Actas']
      parameter name: :id, in: :path, required: true, schema: { type: :string }

      response 200 do
        key :description, 'Acta encontrada'
        content 'application/json' do
          schema do
            key :'$ref', :Acta
          end
        end
      end

      response 404 do
        key :description, 'Acta no encontrada'
      end
    end
  end
end
