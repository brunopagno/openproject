require "api/decorators/single"

module API
  module V3
    module Companies
      class CompanyRepresenter < ::API::Decorators::Single
        link :self do
          {
            href: api_v3_paths.category(represented.id),
            title: represented.name
          }
        end

        links :owningUsers do
          represented.owning_users.map do |owner|
            {
              href: api_v3_paths.user(owner.id),
              name: owner.name
            }
          end
        end

        property :id, render_nil: true
        property :name, render_nil: true

        collection :owning_users,
                   class: ::API::V3::Users::UserRepresenter,
                   embedded: true do
                     property :name
                   end

        def _type
          "Company"
        end
      end
    end
  end
end
