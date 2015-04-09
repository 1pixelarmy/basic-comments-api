class CreateCommentFlags < ActiveRecord::Migration
  def change
    create_table :comment_flags do |t|
      t.references :comment, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.boolean :inappropriate

      t.timestamps null: false
    end
  end
end
