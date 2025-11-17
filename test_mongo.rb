require_relative 'db/mongo'

puts "=== Verificando conexión a MongoDB ==="
begin
  client = DB.client
  puts "✅ Conectado a MongoDB"
  
  # Intenta insertar un documento de prueba
  result = DB.actas.insert_one({ id: "TEST-DIAG", mesa: "TEST" })
  puts "✅ Documento insertado: #{result.inserted_id}"
  
  # Ahora intenta leerlo (use API moderna: `find(...).first`)
  doc = DB.actas.find({ id: "TEST-DIAG" }).first
  if doc
    puts "✅ Documento encontrado: #{doc.inspect}"
  else
    puts "❌ Documento NO encontrado"
  end
  
  # Listar todas las actas
  puts "\n=== Todas las actas ==="
  DB.actas.find.each { |d| puts "  #{d.inspect}" }
  
rescue => e
  puts "❌ Error: #{e.message}"
  puts e.backtrace
end
