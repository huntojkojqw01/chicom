class CreateShozokus < ActiveRecord::Migration[5.1]
  def change
    create_table :shozokus do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
