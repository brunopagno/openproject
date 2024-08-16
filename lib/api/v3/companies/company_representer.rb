require "api/decorators/single"

module API
  module V3
    module Companies
      class CompanyRepresenter < ::API::Decorators::Single
        self_link title_getter: ->(*) { represented.name }

        property :id, render_nil: true
        property :name, render_nil: true

        links :owningUsers do
          represented.owning_users.map do |owner|
            {
              href: api_v3_paths.user(owner.id),
              name: owner.name
            }
          end
        end
        collection :owning_users,
                   representer: ::API::V3::Users::UserRepresenter,
                   embedded: true

        def _type
          "Company"
        end
      end
    end
  end
end
