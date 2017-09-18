require 'httparty'

class Api::V1::PinsController < ApplicationController
skip_before_action :verify_authenticity_token
# before_action :authenticate_user, only: [:create]

  def index
    # HTTParty.post('http://localhost:3000/api/v1/pins', body: { title: "QPMA", image_url: "https://s3.amazonaws.com/makeitreal/pins/lamborghini.jpg"}.to_json, headers: { 'Content-Type' => 'application/json', 'X-User-Email'=> 'josepaez_2@hotmail.com', 'X-Api-Token'=> '20d8cf670e88edb69e02f93ed2aa493d'})
    render json: Pin.all.order('created_at DESC')
  end

  def create
    pin = Pin.new(pin_params)
    email = request.headers['HTTP_X_USER_EMAIL']
    api_token = request.headers['HTTP_X_API_TOKEN']
    if @current_user = User.find_by(email: email)
      if @current_user.api_token == api_token
        pin.save
        render json: pin, status: 201
      else
        pin.errors.add :title, "must be a valid password"
        render json: { errors: pin.errors }, status: 401
      end
    else
      pin.errors.add :title, "must be a valid email"
      render json: { errors: pin.errors }, status: 401
    end
  end

  def destroy
    @pin = Pin.find(params[:id])
    @pin.destroy
    {:status => 204}
  end

  # def authenticate_user
  #   email = request.headers['HTTP_X_USER_EMAIL']
  #   if @current_user = User.find_by(email: email)
  #     api_token = request.headers['HTTP_X_API_TOKEN']
  #     if @current_user.email == email && @current_user.api_token == api_token
  #       puts "Validated User Correctly!! :) "
  #     else
  #       errors.add :email, "must be a valid email"
  #       render nothing: true, status: :unauthorized
  #     end
  #   else
  #       errors.add :email, "must be a valid email"
  #       render nothing: true, status: :unauthorized
  #   end
  # end


  private
    def pin_params
      params.require(:pin).permit(:title, :image_url)
    end
end