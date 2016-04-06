class AddCoverToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cover, :attachment
  end
end
