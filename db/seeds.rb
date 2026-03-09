# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Seeding groups..."

# Personal groups
personal_groups = [
  { name: "Familia", group_type: "familia" },
  { name: "Instituto", group_type: "instituto" },
  { name: "Universidad", group_type: "universidad" }
]

personal_groups.each do |group|
  Group.find_or_create_by!(name: group[:name], group_type: group[:group_type])
end
puts "Created #{personal_groups.size} personal groups"

# Country
Group.find_or_create_by!(name: "España", group_type: "pais")
puts "Created country group"

# Autonomous communities of Spain (17 + 2 autonomous cities)
comunidades_autonomas = [
  "Andalucía",
  "Aragón",
  "Asturias",
  "Islas Baleares",
  "Canarias",
  "Cantabria",
  "Castilla-La Mancha",
  "Castilla y León",
  "Cataluña",
  "Extremadura",
  "Galicia",
  "La Rioja",
  "Madrid",
  "Murcia",
  "Navarra",
  "País Vasco",
  "Valencia",
  "Ceuta",
  "Melilla"
]

comunidades_autonomas.each do |ca|
  Group.find_or_create_by!(name: ca, group_type: "comunidad_autonoma")
end
puts "Created #{comunidades_autonomas.size} autonomous communities"

# All 50 provinces of Spain
provincias = [
  # Andalucía
  "Almería", "Cádiz", "Córdoba", "Granada", "Huelva", "Jaén", "Málaga", "Sevilla",
  # Aragón
  "Huesca", "Teruel", "Zaragoza",
  # Asturias
  "Asturias",
  # Islas Baleares
  "Islas Baleares",
  # Canarias
  "Las Palmas", "Santa Cruz de Tenerife",
  # Cantabria
  "Cantabria",
  # Castilla-La Mancha
  "Albacete", "Ciudad Real", "Cuenca", "Guadalajara", "Toledo",
  # Castilla y León
  "Ávila", "Burgos", "León", "Palencia", "Salamanca", "Segovia", "Soria", "Valladolid", "Zamora",
  # Cataluña
  "Barcelona", "Girona", "Lleida", "Tarragona",
  # Extremadura
  "Badajoz", "Cáceres",
  # Galicia
  "A Coruña", "Lugo", "Ourense", "Pontevedra",
  # La Rioja
  "La Rioja",
  # Madrid
  "Madrid",
  # Murcia
  "Murcia",
  # Navarra
  "Navarra",
  # País Vasco
  "Álava", "Bizkaia", "Gipuzkoa",
  # Valencia
  "Alicante", "Castellón", "Valencia"
]

provincias.each do |provincia|
  Group.find_or_create_by!(name: provincia, group_type: "provincia")
end
puts "Created #{provincias.size} provinces"

puts "Seeding completed! Total groups: #{Group.count}"
