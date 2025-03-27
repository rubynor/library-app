class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def create
    @book = Book.find(params[:book_id])
    @bookmark = current_user.bookmarks.build(book: @book)

    if @bookmark.save
      render json: { bookmarked: true, book_id: @book.id }, status: :created
    else
      render json: { bookmarked: false, errors: @bookmark.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @book = Book.find(params[:book_id])
    @bookmark = current_user.bookmarks.find_by(book: @book)
    
    if @bookmark&.destroy
      render json: { bookmarked: false, book_id: @book.id }
    else
      render json: { error: 'Bookmark not found' }, status: :not_found
    end
  end
end