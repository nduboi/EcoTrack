class CreateRevenues < ActiveRecord::Migration[8.1]
  def change
    create_table :revenues do |t|
      t.string :name
      t.string :description
      t.decimal :amount
      t.date :date
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
