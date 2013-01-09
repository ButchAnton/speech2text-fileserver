class CreateSounds < ActiveRecord::Migration
  def change
    create_table :sounds do |t|
      t.string :sound_file
      t.string :text

      t.timestamps
    end
  end
end
