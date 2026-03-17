class CreateInvitations < ActiveRecord::Migration[8.0]
  def change
    create_table :invitations do |t|
      t.string :email, null: false
      t.string :token, null: false
      t.datetime :expires_at, null: false
      t.string :status, default: "pending"

      t.references :project, null: false, foreign_key: true
      t.references :sender, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :invitations, :token, unique: true
    add_index :invitations, :email
  end
end
