# db/seeds.rb

puts "Start trips' creation"

Trip.create!(name: "Weekend à Paris", destination: "Paris", number_of_travelers: 3, user: User.first)
Trip.create!(name: "Weekend à Barcelone", destination: "Barcelone", number_of_travelers: 5, user: User.first)
Trip.create!(name: "Weekend à Malaga", destination: "Malaga", number_of_travelers: 7, user: User.first)
Trip.create!(name: "Weekend à Lisbonne", destination: "Lisbonne", number_of_travelers: 4, user: User.first)

puts "Seeds done"
