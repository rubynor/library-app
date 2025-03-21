# app/controllers/reviews_controller.rb
class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    @review = current_user.reviews.build(review_params)
    
    if @review.save
      redirect_back fallback_location: root_path, notice: 'Review added successfully.'
    else
      redirect_back fallback_location: root_path, alert: 'Failed to add review.'
    end
  end

  private

  def review_params
    params.require(:review).permit(:book_id, :rating, :content)
  end
end