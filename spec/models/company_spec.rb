require "rails_helper"

RSpec.describe Company do
  describe "#owning_users" do
    subject { described_class.new(owner:) }

    describe "when the company has no parents" do
      let(:owner) { create(:user) }

      it "returns the owner if the company has no parent companies" do
        expect(subject.owning_users).to eq([owner])
      end
    end

    describe "when the company has a single parent" do
      let(:parent_company) { create(:company) }
      let(:owner) { create(:user) }

      before do
        Share.create!(parent: parent_company, child: subject)
      end

      it "returns the owner of the parent company" do
        expect(subject.owning_users).to eq([parent_company.owner])
      end
    end

    describe "when the company has multiple parents" do
      let(:parent_company1) { create(:company) }
      let(:parent_company2) { create(:company) }
      let(:owner) { create(:user) }

      before do
        Share.create!(parent: parent_company1, child: subject)
        Share.create!(parent: parent_company2, child: subject)
      end

      it "returns the owners of all parent companies" do
        expect(subject.owning_users).to eq([parent_company1.owner, parent_company2.owner])
      end
    end

    describe "when the parent share is inactive" do
      let(:parent_company) { create(:company) }
      let(:owner) { create(:user) }

      before do
        Share.create!(parent: parent_company, child: subject, active: false)
      end

      it "does not return the owner of the parent company" do
        expect(subject.owning_users).to eq([owner])
      end
    end

    describe "when there is a cyclic hierarchy" do
      context "and there is no other owner" do
        let(:parent_company) { create(:company) }
        let(:owner) { create(:user) }

        before do
          Share.create!(parent: parent_company, child: subject)
          Share.create!(parent: subject, child: parent_company)
        end

        it "returns an empty value" do
          expect(subject.owning_users).to eq([])
        end
      end

      context "and there is another owner" do
        let(:parent_company1) { create(:company) }
        let(:parent_company2) { create(:company) }
        let(:owner) { create(:user) }

        before do
          Share.create!(parent: parent_company1, child: subject)
          Share.create!(parent: parent_company2, child: subject)
          Share.create!(parent: subject, child: parent_company1)
        end

        it "returns the owners of all parent companies" do
          expect(subject.owning_users).to eq([parent_company2.owner])
        end
      end
    end
  end
end
