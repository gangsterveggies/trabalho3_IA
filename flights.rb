
def new_flight(dep_time, arr_time, id, dd)
  return { departure_time: dep_time, arrival_time: arr_time, id: id, days: dd }
end

$flights = {}

$flights['edinburgh'] = {}
$flights['london'] = {}
$flights['ljubljana'] = {}
$flights['zurich'] = {}
$flights['milan'] = {}

$flights['edinburgh']['london'] = [ new_flight('09:40', '10:50', 'ba4733', ['mo', 'tu', 'we', 'th', 'fr', 'sa', 'su']),
                                    new_flight('13:40', '14:50', 'ba4773', ['mo', 'tu', 'we', 'th', 'fr', 'sa', 'su']),
                                    new_flight('19:40', '20:50', 'ba4833', ['mo', 'tu', 'we', 'th', 'fr', 'su']), ]
$flights['london']['edinburgh'] = [ new_flight('09:40', '10:50', 'ba4732', ['mo', 'tu', 'we', 'th', 'fr', 'sa', 'su']),
                                    new_flight('11:40', '12:50', 'ba4752', ['mo', 'tu', 'we', 'th', 'fr', 'sa', 'su']),
                                    new_flight('18:40', '19:50', 'ba4822', ['mo', 'tu', 'we', 'th', 'fr']), ]
$flights['london']['ljubljana'] = [ new_flight('13:20', '16:20', 'ju201',  ['fr']),
                                    new_flight('13:20', '16:20', 'ju213',  ['su']), ]
$flights['london']['zurich']    = [ new_flight('09:10', '11:45', 'ba614',  ['mo', 'tu', 'we', 'th', 'fr', 'sa', 'su']),
                                    new_flight('14:45', '17:20', 'sr805',  ['mo', 'tu', 'we', 'th', 'fr', 'sa', 'su']), ]
$flights['london']['milan']     = [ new_flight('08:30', '11:20', 'ba510',  ['mo', 'tu', 'we', 'th', 'fr', 'sa', 'su']),
                                    new_flight('11:00', '13:50', 'az459',  ['mo', 'tu', 'we', 'th', 'fr', 'sa', 'su']), ]
$flights['ljubljana']['zurich'] = [ new_flight('11:30', '12:40', 'ju322',  ['tu', 'th']), ]
$flights['ljubljana']['london'] = [ new_flight('11:10', '12:20', 'yu200',  ['fr']),
                                    new_flight('11:25', '12:20', 'yu212',  ['su']), ]
$flights['milan']['london']     = [ new_flight('09:10', '10:00', 'az458',  ['mo', 'tu', 'we', 'th', 'fr', 'sa', 'su']),
                                    new_flight('12:20', '13:10', 'ba511',  ['mo', 'tu', 'we', 'th', 'fr', 'sa', 'su']), ]
$flights['milan']['zurich']     = [ new_flight('09:25', '10:15', 'sr621',  ['mo', 'tu', 'we', 'th', 'fr', 'sa', 'su']),
                                    new_flight('12:45', '13:35', 'sr623',  ['mo', 'tu', 'we', 'th', 'fr', 'sa', 'su']), ]
$flights['zurich']['ljubljana'] = [ new_flight('13:30', '14:40', 'yu323',  ['tu', 'th']), ]
$flights['zurich']['london']    = [ new_flight('09:00', '09:40', 'ba613',  ['mo', 'tu', 'we', 'th', 'fr', 'sa']),
                                    new_flight('16:10', '16:55', 'sr806',  ['mo', 'tu', 'we', 'th', 'fr', 'su']), ]
$flights['zurich']['milan']     = [ new_flight('07:55', '08:45', 'sr620',  ['mo', 'tu', 'we', 'th', 'fr', 'sa', 'su']), ]



def time_to_mins(hs)
  parts = hs.split(':')
  hours = parts[0].to_i
  mins = parts[1].to_i
  mins += hours * 60
end

def day_to_int(d)
  ld = { 'mo' => 0, 'tu' => 1, 'we' => 2, 'th' => 3, 'fr' => 4, 'sa' => 5, 'su' => 6 }
  return ld[d]
end

def int_to_day(d)
  ld = ['mo', 'tu', 'we', 'th', 'fr', 'sa', 'su']
  return ld[d]
end

def add_days(d, x)
  c = day_to_int(d)
  c = (c + x) % 7
  return int_to_day(c)
end

def get_direct_flight_days(origin, destination)
  ud = []
  cnt = $flights[origin][destination].count rescue 0
  if cnt > 0
    $flights[origin][destination].each do |flight|
      ud = ud | flight[:days]
    end
  end
  return ud
end

def search_direct_flights()
  puts "\nInsert the departure city name:"
  origin = gets.chomp
  puts "Insert the arrival city name:"  
  destination = gets.chomp
  
  ud = get_direct_flight_days(origin, destination)

  if ud.count == 0
    puts "\nNo direct flights from #{origin} to #{destination}!"
  end

  puts "\nList of direct flights from #{origin} to #{destination}:"
  $flights[origin][destination].each do |flight|
    puts flight
  end
  puts "\nThere are direct flights from #{origin} to #{destination} on these days:"
  print ud
  puts ""
end

$cnt_routes = 0
$cur_route_cities = []
$cur_route_info = []

def search_routes_dfs(origin, arrival, day, city, time)
  if city == arrival
    $cnt_routes += 1
    puts "Route #{$cnt_routes}"
    $cur_route_info.each do |flight|
      puts "\t#{flight[:origin]} --- (#{flight[:id]}) ---> #{flight[:destination]}"
    end
    return
  end

  cnt = $flights[city].count rescue 0
  if cnt == 0
    return
  end

  $flights[city].each do |destination, flights_list|
    cnt = flights_list.count rescue 0
    if cnt == 0 or $cur_route_cities.include?(destination)
      next
    end
    flights_list.each do |flight|
      if flight[:days].include?(day) and time_to_mins(flight[:departure_time]) >= time + 40
        $cur_route_cities << destination
        $cur_route_info << { origin: city, destination: destination, id: flight[:id] }
        search_routes_dfs(origin, arrival, day, destination, time_to_mins(flight[:arrival_time]))
        $cur_route_cities.pop
        $cur_route_info.pop
      end
    end
  end
end

def search_routes()
  puts "\nInsert the origin city name:"
  origin = gets.chomp
  puts "Insert the arrival city name:"  
  arrival = gets.chomp
  puts "Insert the day to look up:"
  day = gets.chomp

  $cnt_routes = 0
  $cur_route_cities = [origin]
  $cur_route_info = []

  puts "\nRoutes from #{origin} to #{arrival} on #{day}:"
  search_routes_dfs(origin, arrival, day, origin, 0)
  if $cnt_routes == 0
    puts "None"
  end
end

def search_circuits()
  puts "\nInsert the origin/arrival city name:"
  origin = gets.chomp

  puts "How many cities to visit (should be bigger than 0):"
  n = Integer(gets.chomp) rescue 0
  if n == 0
    return
  end

  stops = []
  (0...n).each do |i|
    puts "Insert the name of the city to visit: (#{i}/#{n})" 
    city = gets.chomp
    stops << city
  end

  puts "Insert start day:"
  start_day = gets.chomp

  cnt = 0
  puts "\nPossible orders of visit:"
  stops.permutation.to_a.each do |ord|
    ord.insert(0, origin)
    ord << origin
    ck = true

    (0..n).each do |i|
      ud = get_direct_flight_days(ord[i], ord[i + 1])
      if !ud.include?(add_days(start_day, i))
        ck = false
        break
      end
    end
    if ck
      cnt += 1
      print ord
      puts
    end
  end
  if cnt == 0
    puts "None"
  end
end



def menu()
  puts "\nMenu:"
  puts "(1) Search Direct Flights"
  puts "(2) Search Routes"
  puts "(3) Search Circuits"
  puts "Choose your option:"
  op = gets.chomp
  return Integer(op) rescue -1
end

while 1 do
  case menu()
  when 1
    search_direct_flights()
  when 2
    search_routes()
  when 3
    search_circuits()
  else
    puts "Invalid option!"
  end
end

