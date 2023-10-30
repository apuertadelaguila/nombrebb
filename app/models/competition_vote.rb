# app/models/competition_vote.rb
class CompetitionVote < ApplicationRecord
    belongs_to :competition, class_name: 'Competition'
    belongs_to :bebe, class_name: 'Bebe'
    belongs_to :created_by, class_name: 'User', foreign_key: 'created_by'
end  
