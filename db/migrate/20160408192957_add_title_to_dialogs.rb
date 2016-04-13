class AddTitleToDialogs < ActiveRecord::Migration
  def change
    add_column :dialogs, :title, :string
  end
end
