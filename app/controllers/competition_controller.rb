class CompetitionController < ApplicationController
    include CompetitionHelper

    before_action :authenticate_user!
    before_action :check_all_users_voted, only: [:competicion_femenina, :competicion_masculina]
    after_action :next_round_for_high_priority_bebes, only: [:generar_cuadros]

    IZQUIERDA = 'izquierda'
    DERECHA = 'derecha'

    def competicion_masculina
        @competitions_izquierda_masculina = Competition.where(sexo: 'Hombre', lado: 'izquierda').order(posicion: :asc)
        @competitions_derecha_masculina = Competition.where(sexo: 'Hombre', lado: 'derecha').order(posicion: :asc)
        @final_masculina = Competition.where(sexo: 'Hombre', ronda: 4).first
    end

    def competicion_femenina
        @competitions_izquierda_femenina = Competition.where(sexo: 'Mujer', lado: 'izquierda').order(posicion: :asc)
        @competitions_derecha_femenina = Competition.where(sexo: 'Mujer', lado: 'derecha').order(posicion: :asc)
        @final_femenina = Competition.where(sexo: 'Mujer', ronda: 4).first
    end

    def generar_cuadros
        if all_users_voted?
            Competition.find_each { |c| c.delete } if Competition.all.any?
            # Generar cuadrante masculino
            generar_cuadro('Hombre')

            # Generar cuadrante femenino
            generar_cuadro('Mujer')

            redirect_back fallback_location: root_path, notice: 'Cuadros creados'
        else
            redirect_back fallback_location: root_path, alert: 'Aun no han votado todos los usuarios'
        end
    end

    private

    def generar_cuadro(sexo)
        bebes = Bebe.where(sexo: sexo).order(puntuacion: :desc).to_a
        parejas = []

        while bebes.length >= 2 && parejas.length < 16
            bebe_mayor = bebes.shift
            bebe_menor = bebes.pop

            parejas << [bebe_mayor, bebe_menor]
        end

        competitions_por_lado = 4
        competitions_izquierda = []
        competitions_derecha = []
        positions_izquierda_a = 0
        positions_derecha_a = 0

        parejas.each do |pareja|
            lado = [IZQUIERDA, DERECHA].sample
            
            # Verifica cuántos "Competitions" hay en cada lado
            if lado == IZQUIERDA && competitions_izquierda.count < competitions_por_lado
                competitions_izquierda << lado
                if positions_izquierda_a < 2
                    posicion = "A"
                    positions_izquierda_a += 1
                else
                    posicion = "B"
                end
            elsif lado == DERECHA && competitions_derecha.count < competitions_por_lado
                competitions_derecha << lado
                if positions_derecha_a < 2
                    posicion = "A"
                    positions_derecha_a += 1
                else
                    posicion = "B"
                end
            else
                # Si ya se crearon suficientes "Competitions" en un lado, cambia el lado
                lado = (lado == IZQUIERDA) ? DERECHA : IZQUIERDA
                competitions_izquierda << lado
                if lado == IZQUIERDA
                    if positions_izquierda_a < 2
                        posicion = "A"
                        positions_izquierda_a += 1
                    else
                        posicion = "B"
                    end
                else
                    if positions_derecha_a < 2
                        posicion = "A"
                        positions_derecha_a += 1
                    else
                        posicion = "B"
                    end
                end
            end
            
            # Crea el objeto "Competition" con los "Bebes", el lado, la posición asignados y la ronda inicial
            Competition.create(
                bebe_1: pareja[0],
                bebe_2: pareja[1],
                lado: lado,
                posicion: posicion,
                ronda: 1,
                sexo: sexo
            )
        end
    end

    def check_all_users_voted
        unless all_users_voted?
            flash[:alert] = "¡No todos los usuarios han votado!"
            redirect_back(fallback_location: bebes_path)
        end
    end

    def next_round_for_high_priority_bebes
        competitions = Competition.joins("LEFT JOIN bebes ON bebes.id = competitions.bebe_1 OR bebes.id = competitions.bebe_2").where("bebes.prioridad = 0")
        competitions.each do |c|
            if c.bebe_1.prioridad == 0
                c.ganador = c.bebe_1
                c.save!
            else
                c.ganador = c.bebe_2
                c.save!
            end
        end
    end
end
  