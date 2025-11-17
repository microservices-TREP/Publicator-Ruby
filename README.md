# Publicator-Ruby con Docker

## Requisitos
- Docker
- Docker Compose

## Instalación y Ejecución

### Opción 1: Usar Docker Compose (recomendado)

Esto inicia MongoDB y el servidor gRPC automáticamente:

```bash
cd Publicator-Ruby
docker-compose up --build
```

El servidor estará disponible en:
- **gRPC**: `localhost:50052`
- **HTTP**: `localhost:4000`
- **MongoDB**: `localhost:27017`

### Opción 2: Construir y ejecutar solo el contenedor

```bash
# Construir imagen
docker build -t publicator-ruby .

# Ejecutar contenedor (requiere MongoDB local)
docker run -p 50052:50052 -p 4000:4000 -e MONGO_URL="mongodb://host.docker.internal:27017/trep_publicator" publicator-ruby
```

## Pruebas

### Probar HTTP (desde la máquina host)

```powershell
$body = @{
    id = "ACTA_TEST"
    mesa = "TEST01"
    votos_validos = 123
    departamento = "La Paz"
} | ConvertTo-Json

Invoke-WebRequest -Uri "http://localhost:4000/actas-validadas" `
  -Method POST `
  -Headers @{"Content-Type"="application/json"} `
  -Body $body
```

### Detener los contenedores

```bash
docker-compose down
```

## Notas

- Las gemas se instalan automáticamente dentro del contenedor
- MongoDB se ejecuta en un contenedor separado
- Los datos de MongoDB persisten en un volumen Docker
- Para desarrollo local sin Docker, necesitas resolver el problema de permisos de `grpc` gem
