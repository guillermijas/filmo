# frozen_string_literal: true

672.times do
  email = [*('a'..'z'), *('0'..'9')].sample(8).join
  User.create!(email: email + '@gmail.com', password: 'qwerty123')
end
