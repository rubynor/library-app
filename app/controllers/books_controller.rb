class BooksController < ApplicationController
  before_action :authenticate_user!, except: [:index, :details]
  before_action :set_book, only: [:details, :user_review, :download]
  before_action :set_categories, only: [:new, :create]

  def index
    @books = Book.includes(:user, :reviews, :categories)
    apply_search_filters
    apply_sorting
  end

  def all_reviews
    book = Book.includes(reviews: :user).find_by(id: params[:id])
    
    if book
      reviews = book.reviews.map do |review|
        {
          user: review.user.first_name,
          content: review.content,
          rating: review.rating
        }
      end
      
      render json: { reviews: reviews }
    else
      render json: { error: "Book not found" }, status: :not_found
    end
  end

  def user_review
    return render_unauthorized unless current_user
    return render_not_found("Book") unless @book
    
    review = current_user.reviews.find_by(book_id: @book.id)
    render json: { review: review ? { rating: review.rating, content: review.content } : nil }
  end

  def details
    return render_not_found("Book") unless @book
    
    render json: {
      id: @book.id,
      title: @book.title,
      cover_url: @book.cover_image.attached? ? url_for(@book.cover_image) : nil,
      added_by: "#{@book.user.first_name} #{@book.user.last_name}",
      pages: @book.pages,
      rating_count: @book.reviews.average(:rating) || 0,
      review_count: @book.reviews.count,
      description: @book.description,
      categories: @book.categories.pluck(:name)
    }
  end

  def new
    @book = Book.new
  end

  def create
    @book = current_user.books.build(book_params)
    
    if @book.save
      @book.category_ids = params[:book][:category_ids] if params[:book][:category_ids].present?
      redirect_to books_path, notice: "Book was successfully created."
    else
      flash.now[:alert] = "There was an error creating the book."
      render :new, status: :unprocessable_entity
    end
  end

  def download
    return render_not_found("Book") unless @book
    
    if @book.pdf_file.attached?
      filename = "#{@book.title.parameterize}-#{@book.id}.pdf"
      send_data @book.pdf_file.download,
                filename: filename,
                type: 'application/pdf',
                disposition: 'attachment'
    else
      flash[:alert] = "No PDF file available for this book."
      redirect_to books_path
    end
  end

  private

  def set_book
    @book = Book.includes(:categories).find_by(id: params[:id])
  end

  def set_categories
    @categories = Category.all
  end

  def apply_search_filters
    if params[:query].present?
      query = params[:query].downcase
      @books = @books.where("LOWER(title) LIKE ?", "%#{query}%")
    end
  
    if params[:categories].present?
      category_names = Array(params[:categories]).map(&:downcase)
      category_ids = Category.where("LOWER(name) IN (?)", category_names).pluck(:id)
  
      if category_ids.any?
        @books = @books.joins(:categories).where(categories: { id: category_ids }).distinct
      end
    end
  end  
  

  def apply_sorting
    sort_column = params[:sort_by].in?(%w[title date_added]) ? params[:sort_by] : "date_added"
    sort_order = params[:sort_order] == "asc" ? :asc : :desc

    @books = if sort_column == "date_added"
               @books.order(created_at: sort_order)
             else
               @books.order(title: sort_order)
             end
  end

  def render_unauthorized
    render json: { error: "Not authenticated" }, status: :unauthorized
  end

  def render_not_found(resource)
    render json: { error: "#{resource} not found" }, status: :not_found
  end

  def book_params
    params.require(:book).permit(
      :title,
      :author,
      :description,
      :cover_image,
      :pages,
      :pdf_file,
      category_ids: []
    )
  end
end