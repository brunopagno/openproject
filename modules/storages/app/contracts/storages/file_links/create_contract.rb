#-- copyright
# OpenProject is an open source project management software.
# Copyright (C) 2012-2022 the OpenProject GmbH
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See COPYRIGHT and LICENSE files for more details.
#++

class Storages::FileLinks::CreateContract < BaseContract
  validate :validate_storage_presence
  validate :validate_user_allowed_to_manage
  validate :validate_project_storage_link

  private

  # Check that the current has the permission on the project.
  # model variable is available because the concern is executed inside a contract.
  def validate_user_allowed_to_manage
    unless user.allowed_to?(:manage_file_links, model.container.project)
      errors.add :base, :error_unauthorized
    end
  end

  def validate_storage_presence
    case model.storage
    when Storages::Storage::InexistentStorage
      errors.add(:storage, :does_not_exist)
    when nil
      errors.add(:storage, :blank)
    end
  end

  def validate_project_storage_link
    return if errors.include?(:storage)
    return if model.project.storages.include?(model.storage)

    errors.add(:storage, :not_linked_to_project)
  end
end
