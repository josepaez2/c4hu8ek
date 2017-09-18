require 'httparty'

class Api::V1::PinsController < ApplicationController
before_action :authenticate_user, only: [:create]

# buscar al usuario y ver si está autenticado
# device tiene current user verlo en costsos

  def index
    # HTTParty.post('http://localhost:3000/api/v1/pins', body: { user_id: 1 , title: "QPMA", image_url: "https://s3.amazonaws.com/makeitreal/pins/lamborghini.jpg"}.to_json, headers: { 'Content-Type' => 'application/json', 'X-User-Email'=> 'josepaez_2@hotmail.com', 'X-Api-Token'=> '20d8cf670e88edb69e02f93ed2aa493d'})
    # puts "-------------------"
    # puts  @current_user = current_user
    # puts "-------------------"
    # puts  @current_user = current_user
    # puts "-------------------"
    render json: Pin.all.order('created_at DESC')
  end

  def create
    pin = Pin.new(pin_params)
    if pin.save
      render json: pin, status: 201
    else
      render json: { errors: pin.errors }, status: 422
    end
  end


# body: { user_id: 1 , title: "QPMA", image_url: "https://s3.amazonaws.com/makeitreal/pins/lamborghini.jpg"}.to_json, headers: { 'Content-Type' => 'application/json', 'X-User-Email'=> 'josepaez_2@hotmail.com', 'X-Api-Token'=> '20d8cf670e88edb69e02f93ed2aa493d'})
  # Confirms a valid user.
  def authenticate_user
    @current_user ||= User.find(body[:user_id])
    # @current_user ||= User.find_by(id: body[:user_id])
    puts "@current_user"
    puts @current_user
    puts @current_user.email
    puts headers[':X-User-Email']
    puts @current_user.api_token
    puts headers['X-Api-Token']
  end


  private
    def pin_params
      params.require(:pin).permit(:title, :image_url)
    end
end