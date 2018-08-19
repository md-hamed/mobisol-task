class CreateCustomAttributesProviders < ActiveRecord::Migration[5.2]
  def change
    create_table :custom_attributes_providers do |t|
      t.string :model
      t.string :key

      t.timestamps
    end
  end
end
