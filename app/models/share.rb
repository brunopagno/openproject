class Share < ApplicationRecord
  validate :parent_and_child_are_different

  belongs_to :parent, class_name: "Company"
  belongs_to :child, class_name: "Company"

  scope :active, -> { where(active: true) }

  private

  def parent_and_child_are_different
    errors.add(:base, "Parent and child companies must be different") if parent.id == child.id
  end
end
