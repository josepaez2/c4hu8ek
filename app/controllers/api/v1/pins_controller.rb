# require 'httparty'

class Api::V1::PinsController < ApplicationController
# before_action :authenticate_user!, except: [:index]
before_action :authenticate_user
skip_before_action :verify_authenticity_token

    # HTTParty.post('http://localhost:3000/api/v1/pins', body: { title: "QPMA", image_url: "https://s3.amazonaws.com/makeitreal/pins/lamborghini.jpg"}.to_json, headers: { 'Content-Type' => 'application/json', 'X-User-Email'=> 'josepaez_2@hotmail.com', 'X-Api-Token'=> '20d8cf670e88edb69e02f93ed2aa493d'})
    # HTTParty.get('http://localhost:3000/api/v1/pins', body: { title: "QPMA", image_url: "https://s3.amazonaws.com/makeitreal/pins/lamborghini.jpg"}.to_json, headers: { 'Content-Type' => 'application/json', 'X-User-Email'=> 'josepaez_2@hotmail.com', 'X-Api-Token'=> '20d8cf670e88edb69e02f93ed2aa493d'})
    # HTTParty.delete('http://localhost:3000/api/v1/pins/10', body: {}.to_json, headers: { 'Content-Type' => 'application/json', 'X-User-Email'=> 'josepaez_2@hotmail.com', 'X-Api-Token'=> '20d8cf670e88edb69e02f93ed2aa493d'})

  def index
    render json: Pin.all.order('created_at DESC'), status: 201
  end

  def create
    pin = Pin.new(pin_params)
        pin.save
        render json: pin, status: 201
  end

  def destroy
      @pin = Pin.find(params[:id])
      @pin.destroy
      {:status => 204}
  end

  def authenticate_user
    email = request.headers['HTTP_X_USER_EMAIL']
    api_token = request.headers['HTTP_X_API_TOKEN']
    if @current_user = User.find_by(email: email)
      if @current_user.api_token == api_token
        puts "Authorized User"
      else
        render json: { errors: {password:"must be a valid password"}}, status: 401
      end
    else
     render json: { errors: {email:"must be a valid email"}}, status: 401
    end
  end


  private
    def pin_params
      params.require(:pin).permit(:title, :image_url)
    end
end