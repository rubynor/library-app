class BooksController < ApplicationController
  before_action :authenticate_user!

  def index
    @books = Book.includes(:user, :reviews)

    if params[:query].present?
      @books = @books.where("title LIKE ?", "%#{params[:query]}%")
    end

    if params[:sort_by] == "title"
      @books = @books.order(:title)
    elsif params[:sort_by] == "date_added"
      @books = @books.order(created_at: :desc)
    else
      @books = @books.order(created_at: :desc)
    end
  end

  def details
    book = Book.find_by(id: params[:id])
    if book
      render json: {
        id: book.id,
        title: book.title,
        cover_image_url: book.cover_image_url,
        added_by: book.user.first_name,
        pages: book.pages,
        rating_count: book.reviews.average(:rating) || 0,
        review_count: book.reviews.count,
        description: book.description
      }
    else
      render json: { error: "Book not found" }, status: :not_found
    end
  end
end
