class ReviewsController < ApplicationController
end
class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def new
    @review = current_user.reviews.find_by(book_id: params[:book_id])
    @book = Book.find(params[:book_id])
  end

  def create
    @existing_review = current_user.reviews.find_by(book_id: review_params[:book_id])
    
    if @existing_review
      @existing_review.update(review_params)
      redirect_to book_path(review_params[:book_id]), notice: 'Your review has been updated.'
    else
      @review = current_user.reviews.build(review_params)
      
      if @review.save
        redirect_to book_path(@review.book_id), notice: 'Your review has been added.'
      else
        redirect_back fallback_location: root_path, alert: 'Failed to add review.'
      end
    end
  end

  private

  def review_params
    params.require(:review).permit(:book_id, :rating, :content)
  end
end
