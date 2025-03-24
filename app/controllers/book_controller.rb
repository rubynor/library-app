class BookController < ApplicationController
  before_action :authenticate_user!

  def index
    @books = Book.includes(:user, :reviews)
  end

  def details
    @book = Book.find(params[:id])
    render json: {
      title: @book.title,
      author: @book.author,
      description: @book.description,
      cover_image_url: @book.cover_image_url,
      pages: @book.pages,
      user_email: @book.user.email,
      average_rating: @book.reviews.average(:rating)&.round(1),
      ratings_count: @book.reviews.count,
      reviews_count: @book.reviews.count
    }
  end
end
