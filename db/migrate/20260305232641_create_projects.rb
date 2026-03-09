class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string :name, null: false, limit: 150
      t.string :description, null: false, limit: 500

      t.references :created_by, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
