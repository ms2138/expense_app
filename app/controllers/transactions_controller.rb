class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show edit update ]
  before_action :set_months, only: %i[ index update ]
  
  # GET /transactions or /transactions.json
  def index
    selection = selected_month
    set_month_selection(selection)
    
    @transaction_data = Transaction.chart_data_for_month(selection)
    @chart_data = chart_data_json(@transaction_data.keys, @transaction_data.values)
    @pagy, @transactions = pagy(current_user.transactions.current_month(selection))
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
      @transaction = Transaction.find(params[:id])
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

    def set_months
      @months = 12.downto(1).map { |a| 
        month = Date::MONTHNAMES[a]
        [month, Date.parse(month).month] 
      }.to_h
    end
end
