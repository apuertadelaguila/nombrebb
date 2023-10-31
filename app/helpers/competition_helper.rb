module CompetitionHelper
    def all_users_voted?
        users = User.all
        
        users.each do |user|
            cantidad_enfrentamientos = Enfrentamiento.where(user_id: user.id).count
            return false if cantidad_enfrentamientos != 240
        end
        
        true
    end

    def voted_by_user?(competition, bebe, user)
        vote = CompetitionVote.where(competition_id: competition, bebe_id: bebe, created_by: user.id)
        return true if vote.any?

        false
    end

    def bracket_generated?
        return true if Competition.all.any?
        false
    end

    def all_babies_created?
        return true if Bebe.all.count == 32
        false
    end
end
