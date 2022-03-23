class CreateQuotes < ActiveRecord::Migration[7.0]
  def change
    create_table :quotes do |t|
      t.text :quote
      t.string :author

      t.timestamps
    end
  end
end
