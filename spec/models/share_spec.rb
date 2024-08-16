require "rails_helper"

RSpec.describe Share do
  subject { described_class }

  it "validates that parent and child are different" do
    parent = Company.create(name: "Parent")
    child = Company.create(name: "Child")
    share = subject.new(parent:, child:)

    expect(share.valid?).to be true
  end

  it "is invalid if parent and child are the same" do
    company = Company.create(name: "Company")
    share = subject.new(parent: company, child: company)

    expect(share.valid?).to be false
  end
end
