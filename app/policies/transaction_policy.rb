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

  def update?
    user == record.user
  end
end