class VotacionesController < ApplicationController
    before_action :authenticate_user!, only: [:mostrar_duelo, :votar, :reiniciar_votos] # Asegúrate de que el usuario esté autenticado para crear votaciones
  
    def mostrar_duelo
        @usuario_actual = current_user
        @pares_de_nombres = generar_pares_de_nombres

        #@pares_no_votados = filtrar_pares_no_votados(@usuario_actual, @pares_de_nombres)
      
        if @pares_de_nombres.empty?
            flash[:notice] = '¡Has completado el juego!'
            redirect_to bebes_path
        else
            @par_actual = @pares_de_nombres.sample
            @bebe_1 = Bebe.find(@par_actual[0])
            @bebe_2 = Bebe.find(@par_actual[1])
            @votacion = Votacion.new(user: @usuario_actual, bebe: @bebe_1) # Inicializa con el primer bebé del par
        end
    end

    def votar
        @votacion = Votacion.new(votacion_params)
        @enfrentamiento = Enfrentamiento.new(enfrentamiento_params)

        if @votacion.save && @enfrentamiento.save
            bebe = Bebe.find(params[:votacion][:bebe_id])
            bebe.puntuacion += 1
            bebe.save!
            flash[:success] = '¡Voto registrado con éxito!'
        else
            flash[:error] = 'No se pudo registrar el voto.'
        end
        redirect_back fallback_location: votacions_path
    end

    def reiniciar_votos
        begin
            ActiveRecord::Base.transaction do
                votos = Votacion.where(user_id: current_user)
                enfrentamientos = Enfrentamiento.where(user_id: current_user)
            
                votos.each { |voto| voto.destroy }
                enfrentamientos.each { |enfrentamiento| enfrentamiento.destroy }
            end
        
            flash[:success] = 'Votos reiniciados correctamente'
            redirect_to bebes_path
        rescue ActiveRecord::RecordNotFound => e
            flash[:alert] = "Error: #{e.message}"
            redirect_back fallback_location: root_path
        end
    end
    
    private
    
    def votacion_params
        params.require(:votacion).permit(:bebe_id, :user_id)
    end

    def enfrentamiento_params
        params.require(:votacion).permit(:bebe_1_id, :bebe_2_id, :user_id)
    end
      

    def generar_pares_de_nombres
        enfrentamientos_registrados = obtener_enfrentamientos_registrados

        nombres_masculinos = Bebe.where(sexo: 'Hombre').pluck(:id)
        nombres_femeninos = Bebe.where(sexo: 'Mujer').pluck(:id)

        pares_masculinos = generar_pares_individuales(nombres_masculinos, enfrentamientos_registrados)
        pares_femeninos = generar_pares_individuales(nombres_femeninos, enfrentamientos_registrados)

        pares_totales = pares_masculinos + pares_femeninos
    end

    def generar_pares_individuales(nombres, enfrentamientos_registrados)
        pares = []
        
        nombres.each_with_index do |bebe_1_id, index_1|
            nombres.each_with_index do |bebe_2_id, index_2|
                # Verifica si esta combinación ya ha sido registrada
                unless index_1 == index_2 || enfrentamientos_registrados.include?([bebe_1_id, bebe_2_id]) || enfrentamientos_registrados.include?([bebe_2_id, bebe_1_id])
                    pares << [bebe_1_id, bebe_2_id]
                end
            end
        end
        
        pares
        seen = Set.new

        unique_arrays = pares.select do |array|
            sorted_array = array.sort
            if seen.include?(sorted_array)
                false
            else
                seen.add(sorted_array)
                true
            end
        end
    end      

    def obtener_enfrentamientos_registrados
        # Consulta la tabla Enfrentamientos para obtener las combinaciones de enfrentamientos registradas
        enfrentamientos = Enfrentamiento.where(user_id: @usuario_actual)
        enfrentamientos_registrados = enfrentamientos.map { |enfrentamiento| [enfrentamiento.bebe_1_id, enfrentamiento.bebe_2_id] }

        enfrentamientos_registrados
    end
end