class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.references :comment, index: true, foreign_key: true
      t.references :rating_type, index: true, foreign_key: true
      t.float :value

      t.timestamps null: false
    end
  end
end
