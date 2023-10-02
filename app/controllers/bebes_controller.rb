class BebesController < ApplicationController
    before_action :authenticate_user!

    def index
        @bebes = Bebe.all
        @new_bebe = Bebe.new
    end

    def create
        @bebe = Bebe.new(bebe_params)
        @bebe.created_by = current_user
        set_prioridad

        if @bebe.save
          # Manejar el éxito de la creación del bebé
          flash[:notice] = 'Bebé creado exitosamente.'
          redirect_to :bebes
        else
          # Manejar errores de validación o creación
          redirect_back fallback_location: root_path, alert: 'No se pudo crear el nombre del bebé.'
        end
      end
    
      
      private
    
      def bebe_params
        params.require(:bebe).permit(:nombre, :prioridad, :sexo)
      end

      def set_prioridad
        roles = current_user.roles.map(&:name)
        case
        when roles.include?('padres')
            @bebe.prioridad = 'Alta'
        when roles.include?('familia')
            @bebe.prioridad = 'Media'  
        when roles.include?('amigo')
            @bebe.prioridad = 'Baja'
        else
            @bebe.prioridad = 'Baja'
        end
    end
end
