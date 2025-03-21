Book.destroy_all
Review.destroy_all
Bookmark.destroy_all

users = [
  { email: "fogado@rubynor.com", password: "Test123" },
  { email: "bob@example.com", password: "Test123" },
  { email: "charlie@example.com", password: "Test123" },
  { email: "alice@example.com", password: "Test123" },
  { email: "eve@example.com", password: "Test123" }
].map do |user_attrs|
  User.find_or_create_by(email: user_attrs[:email]) do |user|
    user.password = user_attrs[:password]
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
    cover_image_url: "https://m.media-amazon.com/images/I/71rNH9XgqML.jpg",
    pages: 635,
    user: users.sample
  }
].map do |book_attrs|
  Book.find_or_create_by(title: book_attrs[:title]) do |book|
    book.assign_attributes(book_attrs)
  end
end

reviews = [
  { user: users[0], book: books[0], rating: 5, content: "A brilliant satire with deep meaning!" },
  { user: users[1], book: books[1], rating: 4, content: "Terrifying yet captivating." },
  { user: users[2], book: books[2], rating: 5, content: "An emotional and thought-provoking read." },
  { user: users[3], book: books[3], rating: 4, content: "A mesmerizing look at the American dream." },
  { user: users[4], book: books[4], rating: 5, content: "An intense, gripping, and unforgettable experience." }
]
reviews.each do |review_attrs|
  Review.find_or_create_by(user: review_attrs[:user], book: review_attrs[:book]) do |review|
    review.assign_attributes(review_attrs)
  end
end

bookmarks = [
  { user: users[0], book: books[1] },
  { user: users[1], book: books[2] },
  { user: users[2], book: books[0] },
  { user: users[3], book: books[4] },
  { user: users[4], book: books[3] }
]
bookmarks.each do |bookmark_attrs|
  Bookmark.find_or_create_by(bookmark_attrs)
end

puts "✅ Seed data successfully added!"
