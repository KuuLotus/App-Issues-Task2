class RenameBookColumnToFavorites < ActiveRecord::Migration[6.1]
  def change
    rename_column :favorites, :book_, :book_id
  end
end
