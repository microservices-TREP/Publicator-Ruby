# Usa imagen oficial de Ruby
FROM ruby:3.4

# Establece directorio de trabajo
WORKDIR /app

# Instala dependencias del sistema necesarias para compilar native extensions
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copia el Gemfile e instala dependencias
COPY Gemfile Gemfile.lock* ./
RUN gem install bundler --no-document
RUN bundle install --no-cache

# Copia el código de la aplicación
COPY . .

# Expone los puertos
EXPOSE 50052 4000 4001

# Comando para ejecutar el servidor
CMD ["ruby", "app/server.rb"]
