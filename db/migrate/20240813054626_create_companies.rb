class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string :name, null: false, default: ""
      t.references :owner, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
