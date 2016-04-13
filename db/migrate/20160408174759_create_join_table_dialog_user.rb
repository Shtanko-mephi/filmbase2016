class CreateJoinTableDialogUser < ActiveRecord::Migration
  def change
    create_join_table :dialogs, :users do |t|
      # t.index [:dialog_id, :user_id]
      # t.index [:user_id, :dialog_id]
    end
  end
end
