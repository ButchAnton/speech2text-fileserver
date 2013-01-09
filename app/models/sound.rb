class Sound < ActiveRecord::Base
  attr_accessible :sound_file, :text
  mount_uploader :sound_file, SoundFileUploader
end
