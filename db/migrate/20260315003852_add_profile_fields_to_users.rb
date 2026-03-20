class AddProfileFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :name, :string
    add_column :users, :introduction, :text
    add_column :users, :image_name, :string
  end
end
