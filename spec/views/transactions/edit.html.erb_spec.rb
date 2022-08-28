require 'rails_helper'

RSpec.describe "transactions/edit", type: :view do
  let(:transaction) {
    Transaction.create!(
      description: "MyString",
      amount: "9.99",
      category: nil
    )
  }

  before(:each) do
    assign(:transaction, transaction)
  end

  it "renders the edit transaction form" do
    render

    assert_select "form[action=?][method=?]", transaction_path(transaction), "post" do

      assert_select "input[name=?]", "transaction[description]"

      assert_select "input[name=?]", "transaction[amount]"

      assert_select "input[name=?]", "transaction[category_id]"
    end
  end
end
