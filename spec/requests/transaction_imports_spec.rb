require 'rails_helper'

RSpec.describe "TransactionImports", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/transaction_imports/new"
      expect(response).to have_http_status(:success)
    end
  end

end
