# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

10.times do |i|
  User.create(
      email: "user#{i}@example.com",
      nickname: Faker::GameOfThrones.character,
      password: "password_#{i}",
      password_confirmation: "password_#{i}"
  )
end

100.times do
  Post.create(
      title: Faker::StarWars.wookie_sentence,
      body: Faker::StarWars.quote,
      published_at: Time.now - rand(5).days,
      author_id: User.all.sample.id
  )
end

100.times do
  Comment.create(
      body: Faker::RickAndMorty.quote,
      published_at: Time.now - rand(5).days,
      author_id: User.all.sample.id,
      post_id: Post.all.sample.id
  )
end