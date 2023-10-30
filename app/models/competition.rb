class Competition < ApplicationRecord
    belongs_to :bebe_1, class_name: 'Bebe', foreign_key: 'bebe_1', optional: true
    belongs_to :bebe_2, class_name: 'Bebe', foreign_key: 'bebe_2', optional: true
    belongs_to :ganador, class_name: 'Bebe', foreign_key: 'ganador', optional: true
    has_many :competition_votes
end
