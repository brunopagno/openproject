require "api/v3/companies/company_representer"

module API
  module V3
    module Companies
      class CompaniesAPI < ::API::OpenProjectAPI
        resources :companies do
          route_param :id, type: Integer, desc: "Company ID" do
            after_validation do
              @company = Company.find(params[:id])
            end

            get do
              CompanyRepresenter.new(@company, current_user:)
            end
          end
        end
      end
    end
  end
end
