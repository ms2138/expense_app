require 'rails_helper'

RSpec.describe "transactions/new", type: :view do
  before(:each) do
    assign(:transaction, Transaction.new(
      description: "MyString",
      amount: "9.99",
      category: nil
    ))
  end

  it "renders new transaction form" do
    render

    assert_select "form[action=?][method=?]", transactions_path, "post" do

      assert_select "input[name=?]", "transaction[description]"

      assert_select "input[name=?]", "transaction[amount]"

      assert_select "input[name=?]", "transaction[category_id]"
    end
  end
end
