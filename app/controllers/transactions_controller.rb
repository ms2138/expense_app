class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show edit update ]
  before_action :set_selected_month, only: [:index]
  before_action :set_selected_year, only: [:index]
  after_action :verify_authorized, except: [:index, :destroy_multiple]
  after_action :verify_policy_scoped, only: [:index, :destroy_multiple]
  
  # GET /transactions or /transactions.json
  def index
    set_month_selection(@selected_month)
    set_year_selection(@selected_year)
    
    @transaction_data = Transaction.chart_data_for(current_user, @selected_month, @selected_year)
    @chart_data = chart_data_json(@transaction_data.keys, @transaction_data.values)
    @pagy, @transactions = pagy(policy_scope(Transaction.all_data_for(current_user, @selected_month, @selected_year).ordered))
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
        month = get_month_selection
        year = get_year_selection
          
        transaction_data = Transaction.chart_data_for(current_user, month, year)
        @chart_data = chart_data_json(transaction_data.keys, transaction_data.values)
        @pagy, @transactions = pagy(current_user.transactions.all_data_for(current_user, month, year))

        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(helpers.dom_id(@transaction), partial: 'transactions/category_select', locals: { transaction: @transaction }),
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

  def destroy_multiple   
    respond_to do |format|
      if policy_scope(Transaction).destroy(params[:transaction_ids])
        month = get_month_selection
        year = get_year_selection
          
        transaction_data = Transaction.chart_data_for(current_user, month, year)
        @chart_data = chart_data_json(transaction_data.keys, transaction_data.values)
        @pagy, @transactions = pagy(current_user.transactions.all_data_for(current_user, month, year).ordered)

        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("chart", partial: 'transactions/chart', locals: { chart_data: @chart_data }),
            turbo_stream.update("transaction_table", partial: 'shared/transaction_table', locals: { transactions: @transactions }),
            turbo_stream.update("pagination", partial: 'shared/pagination', locals: { pagy: @pagy })
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

    def set_selected_month
      month_selection = params[:date][:month].to_i unless params[:date].nil?
      @selected_month = month_selection.nil? ? Time.now.month : month_selection
    end

    def set_selected_year
      year_selection = params[:date][:year].to_i unless params[:date].nil?
      @selected_year = year_selection.nil? ? Time.now.year : year_selection
    end

    def set_month_selection(month)
      session[:month_selection] = month
    end

    def set_year_selection(year)
      session[:year_selection] = year
    end

    def get_month_selection
      session[:month_selection]
    end

    def get_year_selection
      session[:year_selection]
    end
end
