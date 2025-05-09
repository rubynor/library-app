class RemovePhilosophyCategory < ActiveRecord::Migration[7.1]
  def up
    Category.find_by(name: "Philosophy")&.destroy
  end

  def down
    Category.create!(name: "Philosophy") unless Category.exists?(name: "Philosophy")
  end
end
