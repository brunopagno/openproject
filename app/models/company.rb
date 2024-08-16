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

  def owning_users
    return [owner] if parent_companies.empty?

    parent_companies.map(&:owning_users).flatten
  end
end
