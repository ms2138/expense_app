class CategoryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user_id: user.id)
    end
  end

  def show?
    user.present?
  end

  def create?
    user.present?
  end

  def new?
    create?
  end

  def edit?
    update?
  end

  def update?
    user.present? && user == record.user
  end

  def destroy?
    user.present? && user == record.user
  end
end
