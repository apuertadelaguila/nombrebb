class AddCreatedByToBebes < ActiveRecord::Migration[7.0]
  def change
    add_column :bebes, :created_by, :integer
  end
end
