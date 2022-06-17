# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

for n in 1..3 do
  User.create!(
    name: "test#{n}",
    email: "#{n}@#{n}",
    password: "#{n}#{n}#{n}#{n}#{n}#{n}"
  )
end

now = Time.current

for n in 1..3 do
  Book.create!(
    title: "test#{n}",
    body: "test#{n}",
    user_id: User.first.id,
    rate: n,
    created_at: now,
    updated_at: now
  )
end