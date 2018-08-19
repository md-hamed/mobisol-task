class CreateCustomAttributes < ActiveRecord::Migration[5.2]
  def change
    create_table :custom_attributes do |t|
      t.string :key
      t.string :value
      t.integer :customizable_id
      t.string :customizable_type

      t.timestamps
    end
  end
end
