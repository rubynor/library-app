class AddDefaultCategories < ActiveRecord::Migration[7.0]
  def up
    Category.create!([
      { name: "Technology" },
      { name: "Philosophy" },
      { name: "Artificial Intelligence" },
      { name: "Cybersecurity" },
      { name: "Cloud Computing" },
      { name: "Software Development" },
      { name: "Data Science" }
    ])
  end

  def down
    Category.where(name: [
      "Technology", "Philosophy", "Artificial Intelligence",
      "Cybersecurity", "Cloud Computing", "Software Development",
      "Data Science"
    ]).destroy_all
  end
end
