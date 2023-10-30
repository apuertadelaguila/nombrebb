class AddCreatedByToCompetitionVotes < ActiveRecord::Migration[7.0]
  def change
    add_column :competition_votes, :created_by, :bigint
  end
end
