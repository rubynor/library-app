Review.destroy_all
Bookmark.destroy_all

users = [
  { email: "fogado@rubynor.com", password: "Test123", first_name: "Fogado", last_name: "Semena" },
  { email: "bob@example.com", password: "Test123", first_name: "Bob", last_name: "Smith" },
  { email: "charlie@example.com", password: "Test123", first_name: "Charlie", last_name: "Johnson" },
  { email: "alice@example.com", password: "Test123", first_name: "Alice", last_name: "Williams" },
  { email: "eve@example.com", password: "Test123", first_name: "Eve", last_name: "Davis" }
].map do |user_attrs|
  User.find_or_create_by(email: user_attrs[:email]) do |user|
    user.password = user_attrs[:password]
    user.first_name = user_attrs[:first_name]
    user.last_name = user_attrs[:last_name]
  end
end

review_texts = [
  "A masterpiece that everyone should read.",
  "Very thought-provoking and well-written!",
  "I couldn't put it down!",
  "An absolute classic!",
  "A bit overrated, but still good.",
  "A unique perspective on human nature.",
  "Changed my life!",
  "An interesting read, though slow at times."
]

books = Book.all

books.each do |book|
  users.sample(3).each do |user|
    next if Review.exists?(user: user, book: book)

    Review.create!(
      user: user,
      book: book,
      rating: rand(3..5),
      content: review_texts.sample
    )
  end
end

bookmarks = users.map do |user|
  { user: user, book: books.sample }
end

bookmarks.each do |bookmark_attrs|
  Bookmark.find_or_create_by(bookmark_attrs)
end

puts "✅ Seed data successfully added!"
