class CreateInstructions < ActiveRecord::Migration
  def change
    create_table :instructions do |t|
      t.integer :step_number
      t.string :content
      t.integer :recipe_id
    end
  end
end
