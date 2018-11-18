class CreatePoliceDistricts < ActiveRecord::Migration[5.2]
  def change
    create_table :police_districts do |t|
      t.string :name

      t.timestamps
    end
  end
end
