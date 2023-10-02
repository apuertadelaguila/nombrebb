class Bebe < ApplicationRecord
    has_many :votacions
    belongs_to :created_by, class_name: "User", foreign_key: "created_by"

    validates :nombre, :sexo, presence: true

    enum prioridad: {
        'Alta' => 0,
        'Media' => 1,
        'Baja' => 2
      }

    enum sexo: {
        'Hombre' => 0,
        'Mujer' => 1
    }
end
