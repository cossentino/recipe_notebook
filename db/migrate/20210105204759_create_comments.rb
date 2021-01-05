class CreateComments < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :content
    end
  end
end
