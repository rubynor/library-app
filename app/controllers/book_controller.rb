class BookController < ApplicationController
  before_action :authenticate_user!

  def index
    @books = Book.includes(:user, :reviews)
  end


  def details
    book = Book.find_by(id: params[:id])
    if book
      render json: {
        id: book.id,
        title: book.title,
        cover_image_url: book.cover_image_url,
        added_by: book.user.email,
        rating: book.reviews.average(:rating) || 0,
        pages: book.pages,
        rating_count: book.reviews.count,
        review_count: book.reviews.count,
        description: book.description
      }
    else
      render json: { error: "Book not found" }, status: :not_found
    end
  end
end
