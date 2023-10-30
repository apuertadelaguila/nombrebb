class CreateCompetitionVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :competition_votes do |t|
      t.references :competition, null: false, foreign_key: true
      t.references :bebe, null: false, foreign_key: true

      t.timestamps
    end
  end
end
