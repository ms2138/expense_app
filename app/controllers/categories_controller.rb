class CategoriesController < ApplicationController
  before_action :set_category, only: %i[ show edit update destroy ]
  before_action :set_user, only: %i[ index show new create destroy ]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  # GET /categories or /categories.json
  def index
    @pagy, @categories = pagy(policy_scope(@user.categories.ordered))
  end

  # GET /categories/1 or /categories/1.json
  def show
    @pagy, @transactions = pagy(policy_scope(@category.transactions.ordered))
  end

  # GET /categories/new
  def new
    @category = authorize @user.categories.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories or /categories.json
  def create
    @category = authorize @user.categories.build(category_params)

    respond_to do |format|
      if @category.save
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend("categories", partial: "category", locals: { user: @user, category: @category }) 
        }
        format.html { redirect_to category_url(@category), notice: "Category was successfully created." }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1 or /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.turbo_stream { 
          render turbo_stream: turbo_stream.update("#{helpers.dom_id(@category)}", partial: "category", locals: { user: @user, category: @category }) 
        }
        format.html { redirect_to category_url(@category), notice: "Category was successfully updated." }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1 or /categories/1.json
  def destroy
    @category.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("#{helpers.dom_id(@category)}") }
      format.html { redirect_to categories_url, notice: "Category was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = authorize Category.find(params[:id])
    end

    def set_user
      @user = current_user
      redirect_to root_url if @user.nil?
    end

    # Only allow a list of trusted parameters through.
    def category_params
      params.require(:category).permit(:name)
    end
end
