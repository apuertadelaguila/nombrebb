class CompetitionVotesController < ApplicationController
    before_action :authenticate_user!
    before_action :check_role, only: [:create]
    before_action :user_voted_competition?, only: [:create]
    after_action :generate_next_round, only: [:create]
  
    def create
        @competition_vote = CompetitionVote.new(competition_id: params[:competition_id].to_i, bebe_id: params[:bebe_id].to_i, created_by: current_user)

        if @competition_vote.save
            if has_2_votes?(@competition_vote.bebe)
                competition = Competition.find(@competition_vote.competition.id)
                competition.ganador = @competition_vote.bebe
                competition.save!

                if competition.ronda == 4 && competition.sexo == 'Hombre'
                    redirect_to ganador_masculino_path, notice: 'Tenemos ganador' and return
                end

                if competition.ronda == 4 && competition.sexo == 'Mujer'
                    redirect_to ganador_femenino_path, notice: 'Tenemos ganador' and return
                end
            end

            if @competition_vote.competition.sexo == 'Hombre'
                redirect_back fallback_location: cuadro_masculino_path, notice: 'Voto creado'
            else
                redirect_back fallback_location: cuadro_femenino_path, notice: 'Voto creado'
            end
        else
            if @competition_vote.competition.sexo == 'Hombre'
                redirect_back fallback_location: cuadro_masculino_path, alert: 'Algo fue mal creando el voto'
            else
                redirect_back fallback_location: cuadro_femenino_path, alert: 'Algo fue mal creando el voto'
            end
        end
    end

    def delete
        vote = CompetitionVote.where(competition_id: params[:competition_id].to_i, bebe_id: params[:bebe_id], created_by: current_user ).first
        if vote.destroy!
            if vote.competition.sexo == 'Hombre'
                redirect_back fallback_location: cuadro_masculino_path, notice: 'Voto borrado'
            else
                redirect_back fallback_location: cuadro_femenino_path, notice: 'Voto borrado'
            end
        else
            if @vote.competition.sexo == 'Hombre'
                redirect_back fallback_location: cuadro_masculino_path, alert: 'Algo fue mal borrando el voto'
            else
                redirect_back fallback_location: cuadro_femenino_path, alert: 'Algo fue mal borrando el voto'
            end
        end
    end
  
    private
  
    def check_role
      unless current_user && current_user.has_role?('padres')
        redirect_to root_path, alert: 'No estás autorizado para realizar esta acción.'
      end
    end

    def user_voted_competition?
        vote = CompetitionVote.where(competition_id: params[:competition_id], created_by: current_user.id)
        
        if vote.any?
            if Competition.find(params[:competition_id]).sexo == 'Hombre'
                redirect_to cuadro_masculino_path, alert: 'Ya has votado.'
            else
                redirect_to cuadro_femenino_path, alert: 'Ya has votado.'
            end
        end
    end

    def has_2_votes?(bebe)
        return true if bebe.competition_votes.select { |v| v.competition_id == params[:competition_id].to_i}.count == 2
        false
    end

    def generate_next_round
        competition1 = Competition.find(params[:competition_id].to_i)
        if competition1.ronda == 1
            competition2 = Competition.where(posicion: competition1.posicion, lado: competition1.lado, ronda: competition1.ronda, sexo: competition1.sexo).filter { |c| c.id != competition1.id}.first
            if competition1.ganador.present? && competition2.ganador.present?
                Competition.create(bebe_1: competition2.ganador, bebe_2: competition1.ganador, ronda: competition1.ronda + 1, lado: competition1.lado, posicion: competition1.posicion, sexo: competition1.sexo)
            else
                return
            end
        elsif competition1.ronda == 2
            competition2 = Competition.where(lado: competition1.lado, ronda: competition1.ronda, sexo: competition1.sexo).filter { |c| c.id != competition1.id && c.posicion != competition1.posicion }.first
            if competition1.ganador.present? && competition2.ganador.present?
                Competition.create(bebe_1: competition2.ganador, bebe_2: competition1.ganador, ronda: competition1.ronda + 1, lado: competition1.lado, posicion: competition1.posicion, sexo: competition1.sexo)
            else
                return
            end
        elsif competition1.ronda == 3
            competition2 = Competition.where(ronda: competition1.ronda, sexo: competition1.sexo).filter { |c| c.lado != competition1.lado && c.id != competition1.id }.first
            if competition1.ganador.present? && competition2&.ganador.present?
                Competition.create(bebe_1: competition2.ganador, bebe_2: competition1.ganador, ronda: competition1.ronda + 1, sexo: competition1.sexo)
            else
                return
            end
        end
    end
  end
  