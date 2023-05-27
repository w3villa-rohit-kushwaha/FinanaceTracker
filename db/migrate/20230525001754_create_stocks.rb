class CreateStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks do |t|
      t.string :ticker
      t.decimal :last_price
      t.string :name

      t.timestamps
    end
  end
end
