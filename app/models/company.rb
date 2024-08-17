class Company < ApplicationRecord
  belongs_to :owner, class_name: "User"

  has_many :provided_shares, -> { active }, class_name: "Share",
                                            foreign_key: :child_id,
                                            inverse_of: :child,
                                            dependent: :destroy
  # parents of provided shares are parent companies
  has_many :parent_companies, through: :provided_shares, source: :parent

  has_many :owned_shares, -> { active }, class_name: "Share",
                                         foreign_key: :parent_id,
                                         inverse_of: :parent,
                                         dependent: :destroy
  # children of owned shares are child companies
  has_many :child_companies, through: :owned_shares, source: :child

  #   def owning_users
  #     @owning_users ||= fetch_owning_users
  #   end
  #
  #   def fetch_owning_users(visited = [])
  #     return [owner] if parent_companies.empty?
  #     return [] if visited.include?(id)
  #
  #     visited << id
  #     parent_companies.map { |parent| parent.fetch_owning_users(visited) }.flatten
  #   end

  def owning_users
    stack = [self]
    visited = []
    result = []

    until stack.empty?
      current = stack.pop
      next if visited.include?(current.id)

      visited << current.id

      if current.parent_companies.empty?
        result << current.owner
      else
        stack.concat(current.parent_companies)
      end
    end

    result
  end
end
