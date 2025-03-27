class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def create
    @book = Book.find(params[:book_id])
    @bookmark = current_user.bookmarks.build(book: @book)

    respond_to do |format|
      if @bookmark.save
        format.turbo_stream
      else
        format.turbo_stream { 
          render turbo_stream: turbo_stream.replace("book_#{@book.id}_bookmark", 
            partial: 'bookmarks/error', 
            locals: { book: @book, errors: @bookmark.errors.full_messages }) 
        }
      end
    end
  end

  def destroy
    @book = Book.find(params[:book_id])
    @bookmark = current_user.bookmarks.find_by(book: @book)

    respond_to do |format|
      if @bookmark&.destroy
        format.turbo_stream
      else
        format.turbo_stream { 
          render turbo_stream: turbo_stream.replace("book_#{@book.id}_bookmark", 
            partial: 'bookmarks/error', 
            locals: { book: @book, errors: ['Bookmark not found'] }) 
        }
      end
    end
  end
end