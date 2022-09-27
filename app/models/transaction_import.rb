class TransactionImport
  include ActiveModel::Model
  include ActiveModel::Conversion
  include ActiveModel::Validations
  require 'roo'

  attr_accessor :file, :user_id

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def save
    if imported_transactions.map(&:valid?).all?
      imported_transactions.each(&:save!)
      true
    else
      imported_transactions.each_with_index do |transaction, index|
        transaction.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+2}: #{message}"
        end
      end
      false
    end
  end

  def imported_transactions
    @imported_transactions ||= load_imported_transaction
  end

  def load_imported_transaction
    spreadsheet = open_file
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).map do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      transaction = Transaction.new
      transaction.user_id = user_id
      transaction.attributes = row.to_hash.slice("posted_at", "description", "amount")

      category = Category.where(user_id: user_id).find_by(name: row["category"]) || 
                 Category.where(user_id: user_id).find_by(name: "Miscellaneous")
      transaction.category_id ||= category.id
      transaction
    end
  end

    def open_file
      case File.extname(file.original_filename)
      when ".csv", ".xls", ".xlsx" then Roo::Spreadsheet.open(file.path)
      else raise "Unknown file type: #{file.original_filename}"
      end
    end
end
