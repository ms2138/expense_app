class UserPolicy < ApplicationPolicy
  def show?
    user.present? && user.id == record.id
  end
end
