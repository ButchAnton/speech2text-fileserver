require 'speech'

class SoundsController < ApplicationController
  # GET /sounds
  # GET /sounds.json
  def index
    @sounds = Sound.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sounds }
    end
  end

  # GET /sounds/1
  # GET /sounds/1.json
  def show
    @sound = Sound.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sound }
    end
  end

  # GET /sounds/new
  # GET /sounds/new.json
  def new
    @sound = Sound.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sound }
    end
  end

  # GET /sounds/1/edit
  def edit
    @sound = Sound.find(params[:id])
  end

  # POST /sounds
  # POST /sounds.json
  def create

    if params[:sound]
      puts "params[:sound] is valid: #{params[:sound].inspect}"

    else
      puts "params[:sound] is nil"      
    end

    @sound = Sound.new(params[:sound])
    @sound.text = toText(@sound)


    respond_to do |format|
      if @sound.save
        format.html { redirect_to @sound, notice: 'Sound was successfully created.' }
        format.json { render json: @sound, status: :created, location: @sound, text: @sound.text }
      else
        format.html { render action: "new" }
        format.json { render json: @sound.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sounds/1
  # PUT /sounds/1.json
  def update
    @sound = Sound.find(params[:id])

    respond_to do |format|
      if (@sound.update_attributes(params[:sound]) && @sound.update_attributes(:text => toText(@sound)))
        format.html { redirect_to @sound, notice: 'Sound was successfully updated.' }
        format.json { render json: @sound, status: :updated, location: @sound, text: @sound.text }
      else
        format.html { render action: "edit" }
        format.json { render json: @sound.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sounds/1
  # DELETE /sounds/1.json
  def destroy
    @sound = Sound.find(params[:id])
    @sound.destroy

    respond_to do |format|
      format.html { redirect_to sounds_url }
      format.json { head :no_content }
    end
  end

  private

  # Given a Sound, locate the asset in the file system, convert it to text, and return the text.

  def toText(sound)
    rails_root_dir = Rails.root.to_s
    public_dir = "/public"
    sound_file_dir = sound.sound_file.to_s
    sound_file_path = rails_root_dir + public_dir + sound_file_dir
    ls_results = system("ls -l #{sound_file_path}")
    puts "sound_file_path = #{sound_file_path}: #{ls_results}"
    puts "which ffmpeg: #{system("which ffmpeg")}"
    puts "ls -lR /app/vendor: #{system("ls -l /app/vendor")}"
    puts "echo $PATH: #{system("echo $PATH")}"
    # puts "ls -R: #{system("ls -R")}"
    audio = Speech::AudioToText.new(sound_file_path, :verbose => true)
    if audio
      puts "audio is valid: #{audio.inspect}"
    else
      puts "audio is nil"
    end
    text = audio.to_text
    return text
  end

end
