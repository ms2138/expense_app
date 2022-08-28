class TransactionImport
  include ActiveModel::Model
  include ActiveModel::Conversion
  include ActiveModel::Validations


  attr_accessor :file, :user_id

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end
end
