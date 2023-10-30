class CreateCompetitions < ActiveRecord::Migration[7.0]
  def change
    create_table :competitions do |t|
      t.integer :bebe_1
      t.integer :bebe_2
      t.integer :ganador
      t.integer :ronda
      t.string :lado
      t.string :posicion
      t.string :sexo
      t.integer :score

      t.timestamps
    end
  end
end
