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
      puts "params[:sound] is valid"
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
    audio = Speech::AudioToText.new(Rails.root.to_s + '/public' + sound.sound_file.to_s, :verbose => true)
    text = audio.to_text
    return text
  end

end
