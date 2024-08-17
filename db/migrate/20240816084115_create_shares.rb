class CreateShares < ActiveRecord::Migration[7.1]
  def change
    create_table :shares do |t|
      t.boolean :active, null: false, default: true
      t.references :parent, foreign_key: { to_table: :companies }, null: false
      t.references :child, foreign_key: { to_table: :companies }, null: false

      t.timestamps
    end
  end
end
