class WishesController < ApplicationController
  before_action :set_wish, only: %i[ show edit update destroy ]

  # GET /wishes or /wishes.json
  def index
    @wishes = Wish.includes(:user)
    apply_search_filters
    apply_sorting
  end

  # GET /wishes/1 or /wishes/1.json
  def show
  end

  # GET /wishes/new
  def new
    @wish = Wish.new
  end

  # GET /wishes/1/edit
  def edit
  end

  # POST /wishes or /wishes.json
  def create
    @wish = Wish.new(wish_params)
    @wish.user = current_user  # Assign the currently logged-in user

    respond_to do |format|
      if @wish.save
        format.html { redirect_to wishes_path, notice: "Wish was successfully created." }
        format.json { render :show, status: :created, location: @wish }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @wish.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wishes/1 or /wishes/1.json
  def update
    respond_to do |format|
      if @wish.update(wish_params)
        format.html { redirect_to @wish, notice: "Wish was successfully updated." }
        format.json { render :show, status: :ok, location: @wish }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @wish.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wishes/1 or /wishes/1.json
  def destroy
    @wish.destroy!

    respond_to do |format|
      format.html { redirect_to wishes_path, status: :see_other, notice: "Wish was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_wish
    @wish = Wish.find(params[:id])
  end

  # Apply search filtering for wishes
  def apply_search_filters
    if params[:query].present?
      query = params[:query].downcase
      @wishes = @wishes.where("LOWER(title) LIKE ? OR LOWER(author) LIKE ?", "%#{query}%", "%#{query}%")
    end
  end

  # Apply sorting for wishes
  def apply_sorting
    sort_column = params[:sort_by].in?(%w[title date_added]) ? params[:sort_by] : "date_added"
    sort_order = params[:sort_order] == "asc" ? :asc : :desc

    @wishes = if sort_column == "date_added"
               @wishes.order(created_at: sort_order)
             else
               @wishes.order(title: sort_order)
             end
  end

  # Only allow a list of trusted parameters through.
  def wish_params
    params.require(:wish).permit(:title, :author, :cover_image)
  end
end