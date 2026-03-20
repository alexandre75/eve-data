regions = [
  { name: "The Forge",   eve_id: 10000002 }, # Jita
  { name: "Domain",      eve_id: 10000043 }, # Amarr
  { name: "Sinq Laison", eve_id: 10000032 }, # Dodixie
  { name: "Metropolis",  eve_id: 10000042 }, # Hek
  { name: "Heimatar",    eve_id: 10000030 }, # Rens
]

stations = [
  { name: "Jita IV - Moon 4 - Caldari Navy Assembly Plant", eveid: 60003760, region_eve_id: 10000002 },
  { name: "Amarr VIII (Oris) - Emperor Family Academy",     eveid: 60008494, region_eve_id: 10000043 },
  { name: "Dodixie IX - Moon 20 - Federation Navy Assembly Plant", eveid: 60011866, region_eve_id: 10000032 },
  { name: "Hek VIII - Moon 12 - Boundless Creation Factory", eveid: 60005686, region_eve_id: 10000042 },
  { name: "Rens VI - Moon 8 - Brutor Tribe Treasury",       eveid: 60004588, region_eve_id: 10000030 },
]

regions.each do |r|
  Region.find_or_create_by(eve_id: r[:eve_id]) do |region|
    region.name = r[:name]
  end
end

stations.each do |s|
  region = Region.find_by(eve_id: s[:region_eve_id])
  region.stations.find_or_create_by(eveid: s[:eveid]) do |station|
    station.name = s[:name]
  end
end
