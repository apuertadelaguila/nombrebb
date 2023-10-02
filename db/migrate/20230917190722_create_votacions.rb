class CreateVotacions < ActiveRecord::Migration[7.0]
  def change
    create_table :votacions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :bebe, null: false, foreign_key: true

      t.timestamps
    end
  end
end
