class TransactionImportsController < ApplicationController
  def new
    @transaction_import = TransactionImport.new
  end

  def create
    @transaction_import = TransactionImport.new(params[:transaction_import])
    respond_to do |format|
      if @transaction_import.save
        format.html { redirect_to transactions_path, notice: "Imported successfully." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end
end
