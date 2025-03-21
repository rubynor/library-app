class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.text :description
      t.string :cover_image_url
      t.integer :pages
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
