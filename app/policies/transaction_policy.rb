class TransactionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user_id: user.id)
    end
  end

  def show?
    user == record.user
  end

  def edit?
    update?
  end

  def update_chart?
    user == record.user
  end

  def update_category?
    user == record.user
  end
end
