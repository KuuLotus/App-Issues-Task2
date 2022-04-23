class RenameBookColumnToBookComments < ActiveRecord::Migration[6.1]
  def change
    rename_column :book_comments, :book_, :book_id
  end
end