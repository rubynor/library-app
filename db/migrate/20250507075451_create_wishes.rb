class CreateWishes < ActiveRecord::Migration[7.1]
  def change
    create_table :wishes do |t|
      t.string :title
      t.string :author
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
