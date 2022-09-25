class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show edit update ]
  before_action :set_months, only: %i[ index update ]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index
  
  # GET /transactions or /transactions.json
  def index
    month_selection = selected_month
    year = Time.now.year
    set_month_selection(month_selection)
    
    @transaction_data = Transaction.chart_data_for_month(month_selection, year)
    @chart_data = chart_data_json(@transaction_data.keys, @transaction_data.values)
    @pagy, @transactions = pagy(policy_scope(Transaction.current_month(month_selection, year)))
  end

  # GET /transactions/1 or /transactions/1.json
  def show
  end

  # GET /transactions/1/edit
  def edit
  end

  # PATCH/PUT /transactions/1 or /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        month_selection = get_month_selection
          
        if month_selection == @months[Date::MONTHNAMES[month_selection]]
          year = Time.now.year
          transaction_data = Transaction.chart_data_for_month(month_selection, year)
          @chart_data = chart_data_json(transaction_data.keys, transaction_data.values)
          @pagy, @transactions = pagy(current_user.transactions.current_month(month_selection, year))
        end

        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(helpers.dom_id(@transaction), partial: 'transactions/category_form', locals: { transaction: @transaction }),
            turbo_stream.update("chart", partial: 'transactions/chart', locals: { chart_data: @chart_data })
          ]
        end
        format.html { redirect_to transaction_url(@transaction), notice: "Transaction was successfully updated." }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = authorize Transaction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def transaction_params
      params.require(:transaction).permit(:posted_at, :description, :amount, :category_id)
    end

    def chart_data_json(keys, values)
      chart_data = {
        labels: keys,
        datasets: [{
          data: values,
          backgroundColor: [
            'rgba(246, 109, 68, 0.9)',
            'rgba(45, 135, 187, 0.5)',
            'rgba(100, 194, 166, 0.5)',
            'rgba(230, 246, 157, 0.5)',
            'rgba(254, 174, 101, 0.5)',
            'rgba(0, 63, 92, 0.5)',
            'rgba(170, 222, 167, 0.5)',
            'rgba(88, 80, 141, 0.5)',
          ],
        }]
      }.to_json
    end

    def selected_month
      month = params[:month].to_i
      selected_month = month == 0 && !month.nil? ? Time.now.month : month
      return selected_month
    end

    def set_month_selection(month)
      session[:month_selection] = month
    end

    def get_month_selection
      session[:month_selection]
    end

    def set_months
      @months = 12.downto(1).map { |a| 
        month = Date::MONTHNAMES[a]
        [month, Date.parse(month).month] 
      }.to_h
    end
end
