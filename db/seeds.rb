672.times do
  email = [*('a'..'z'),*('0'..'9')].shuffle[0,8].join
  User.create!(email: email + '@gmail.com', password: 'qwerty123')
end