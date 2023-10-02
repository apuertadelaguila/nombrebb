class CreateBebes < ActiveRecord::Migration[7.0]
  def change
    create_table :bebes do |t|
      t.string :nombre
      t.integer :prioridad
      t.integer :sexo
      t.integer :puntuacion, default: 0

      t.timestamps
    end
  end
end
