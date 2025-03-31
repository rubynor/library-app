class AddDefaultCategories < ActiveRecord::Migration[7.0]
  def up
    Category.create!([
      { name: "Fiction" },
      { name: "Non-Fiction" },
      { name: "Science" },
      { name: "Technology" },
      { name: "History" },
      { name: "Philosophy" },
      { name: "Self-Help" },
      { name: "Business" },
      { name: "Health & Wellness" },
      { name: "Fantasy" },
      { name: "Mystery" },
      { name: "Biography" }
    ])
  end

  def down
    Category.where(name: [
      "Fiction", "Non-Fiction", "Science", "Technology", "History",
      "Philosophy", "Self-Help", "Business", "Health & Wellness",
      "Fantasy", "Mystery", "Biography"
    ]).destroy_all
  end
end
