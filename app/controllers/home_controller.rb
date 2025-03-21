class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @books = Book.includes(:user, :reviews) # Fetch books with associations for efficiency
  end
end
