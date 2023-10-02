class CreateEnfrentamientos < ActiveRecord::Migration[7.0]
  def change
    create_table :enfrentamientos do |t|
      t.integer :bebe_1_id, null: false
      t.integer :bebe_2_id, null: false

      t.timestamps
    end

    # Agrega índices para las columnas bebe_1_id y bebe_2_id
    add_index :enfrentamientos, :bebe_1_id
    add_index :enfrentamientos, :bebe_2_id
  end
end
