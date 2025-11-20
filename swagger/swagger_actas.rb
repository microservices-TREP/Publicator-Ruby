require 'swagger/blocks'

class SwaggerActas
  include Swagger::Blocks

  # -----------------------------------------------------------
  # GET /actas  -  LISTA DE ACTAS
  # -----------------------------------------------------------
  swagger_path '/actas' do
    operation :get do
      key :summary, 'Lista todas las actas (solo versión más reciente por ID)'
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

    # POST /actas
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

  # -----------------------------------------------------------
  # GET /actas/{id}
  # -----------------------------------------------------------
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

  # -----------------------------------------------------------
  # NUEVOS ENDPOINTS DE ESTADÍSTICAS
  # -----------------------------------------------------------

  # Totales por partido (nacional)
  swagger_path '/stats/partidos' do
    operation :get do
      key :summary, 'Votos totales por partido (nacional)'
      key :tags, ['Estadísticas']

      response 200 do
        key :description, 'Votos por partido'
        content 'application/json' do
          schema type: :array do
            items do
              property :partido do
                key :type, :string
              end
              property :votos do
                key :type, :integer
              end
            end
          end
        end
      end
    end
  end

  # Stats por departamento
  swagger_path '/stats/departamentos' do
    operation :get do
      key :summary, 'Estadísticas agregadas por departamento'
      key :tags, ['Estadísticas']

      response 200 do
        key :description, 'Estadísticas por departamento'
        content 'application/json' do
          schema type: :array do
            items do
              property :departamento do
                key :type, :string
              end
              property :votos_validos do
                key :type, :integer
              end
              property :votos_invalidos do
                key :type, :integer
              end
              property :total_actas do
                key :type, :integer
              end
              property :votos_partidos do
                key :type, :array
                items do
                  property :partido do
                    key :type, :string
                  end
                  property :votos do
                    key :type, :integer
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  # Stats por provincia
  swagger_path '/stats/provincias' do
    operation :get do
      key :summary, 'Estadísticas agregadas por provincia'
      key :tags, ['Estadísticas']

      response 200 do
        key :description, 'Estadísticas por provincia'
        content 'application/json' do
          schema type: :array do
            items do
              property :departamento do
                key :type, :string
              end
              property :provincia do
                key :type, :string
              end
              property :votos_validos do
                key :type, :integer
              end
              property :votos_invalidos do
                key :type, :integer
              end
              property :total_actas do
                key :type, :integer
              end
              property :votos_partidos do
                key :type, :array
                items do
                  property :partido do
                    key :type, :string
                  end
                  property :votos do
                    key :type, :integer
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  # Stats por municipio
  swagger_path '/stats/municipios' do
    operation :get do
      key :summary, 'Estadísticas agregadas por municipio'
      key :tags, ['Estadísticas']

      response 200 do
        key :description, 'Estadísticas por municipio'
        content 'application/json' do
          schema type: :array do
            items do
              property :departamento do
                key :type, :string
              end
              property :provincia do
                key :type, :string
              end
              property :municipio do
                key :type, :string
              end
              property :votos_validos do
                key :type, :integer
              end
              property :votos_invalidos do
                key :type, :integer
              end
              property :total_actas do
                key :type, :integer
              end
              property :votos_partidos do
                key :type, :array
                items do
                  property :partido do
                    key :type, :string
                  end
                  property :votos do
                    key :type, :integer
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  # Stats por recinto
  swagger_path '/stats/recintos' do
    operation :get do
      key :summary, 'Estadísticas agregadas por recinto'
      key :tags, ['Estadísticas']

      response 200 do
        key :description, 'Estadísticas por recinto'
        content 'application/json' do
          schema type: :array do
            items do
              property :recinto do
                key :type, :string
              end
              property :votos_validos do
                key :type, :integer
              end
              property :votos_invalidos do
                key :type, :integer
              end
              property :total_actas do
                key :type, :integer
              end
              property :votos_partidos do
                key :type, :array
                items do
                  property :partido do
                    key :type, :string
                  end
                  property :votos do
                    key :type, :integer
                  end
                end
              end
            end
          end
        end
      end
    end
  end

end
