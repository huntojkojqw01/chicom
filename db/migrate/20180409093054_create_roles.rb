class CreateRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :roles do |t|
      t.string :code
      t.string :name
      t.integer :rank, default: 0

      t.timestamps
    end
  end
end
