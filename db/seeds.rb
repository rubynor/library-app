Book.destroy_all
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

books = [
  {
    title: "Animal Farm",
    author: "George Orwell",
    description: "A political fable reflecting events leading up to the Russian Revolution.",
    cover_image_url: "https://m.media-amazon.com/images/I/71JUJ6pGoIL.jpg",
    pages: 112,
    user: users.sample
  },
  {
    title: "1984",
    author: "George Orwell",
    description: "A dystopian novel that delves into totalitarianism and surveillance.",
    cover_image_url: "https://m.media-amazon.com/images/I/71kxa1-0mfL.jpg",
    pages: 328,
    user: users.sample
  },
  {
    title: "To Kill a Mockingbird",
    author: "Harper Lee",
    description: "A novel about racial injustice in the Deep South.",
    cover_image_url: "https://m.media-amazon.com/images/I/81gepf1eMqL.jpg",
    pages: 281,
    user: users.sample
  },
  {
    title: "The Great Gatsby",
    author: "F. Scott Fitzgerald",
    description: "A novel about the American dream and the roaring twenties.",
    cover_image_url: "https://m.media-amazon.com/images/I/81af+MCATTL.jpg",
    pages: 180,
    user: users.sample
  },
  {
    title: "Moby-Dick",
    author: "Herman Melville",
    description: "The epic tale of obsession and revenge on the high seas.",
    cover_image_url: "https://covers.storytel.com/jpg-640/9783736800748.5677c285-990e-4d28-8ad4-edaab19c59a9?optimize=high&quality=70&width=600",
    pages: 635,
    user: users.sample
  }
].map do |book_attrs|
  Book.find_or_create_by(title: book_attrs[:title]) do |book|
    book.assign_attributes(book_attrs)
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
