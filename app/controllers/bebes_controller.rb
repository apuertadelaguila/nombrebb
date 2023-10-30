class BebesController < ApplicationController
    before_action :authenticate_user!

    def index
        @bebes = Bebe.order(puntuacion: :desc)
        @new_bebe = Bebe.new
    end

    def create
        if Bebe.where(created_by: current_user, sexo: bebe_params[:sexo]).count < 8
            @bebe = Bebe.new(bebe_params)
            @bebe.created_by = current_user

            if @bebe.save
            # Manejar el éxito de la creación del bebé
            flash[:notice] = 'Bebé creado exitosamente.'
            redirect_to :bebes
            else
            # Manejar errores de validación o creación
            redirect_back fallback_location: root_path, alert: 'No se pudo crear el nombre del bebé.'
            end
        else
            redirect_back fallback_location: root_path, alert: 'Has creado el máximo de bebés.'
        end
    end
    
      
    private

    def bebe_params
        params.require(:bebe).permit(:nombre, :prioridad, :sexo)
    end
end
