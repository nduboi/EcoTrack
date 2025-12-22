class CreateAccounts < ActiveRecord::Migration[8.1]
  def change
    create_table :accounts, if_not_exists: true do |t|
      t.string :name
      t.string :account_type
      t.decimal :balance
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
