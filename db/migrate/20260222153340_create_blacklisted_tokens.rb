class CreateBlacklistedTokens < ActiveRecord::Migration[8.0]
  def change
    create_table :blacklisted_tokens do |t|
      t.string :token, null: false
      t.datetime :expire_at, null: false

      t.timestamps
    end
  end
end
