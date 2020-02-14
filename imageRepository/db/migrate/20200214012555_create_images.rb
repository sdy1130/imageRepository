class CreateImages < ActiveRecord::Migration[6.0]
  def change
    create_table :images do |t|
      t.string :title
      t.boolean :privacy
      t.string :street
      t.string :city
      t.string :province
      t.string :country
      t.string :address
      t.decimal :latitude
      t.decimal :longitude

      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end