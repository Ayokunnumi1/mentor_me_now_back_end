class Api::V1::UsersController < ApplicationController
  # POST /api/v1/users
  #
  # This method creates a new user. It expects a JSON payload with a "user" key,
  # under which it expects a "username" key with the username as the value.
  #
  # If the user is successfully created, it returns a JSON representation of the
  # user with a status of :created (201).
  #
  # If the user is not successfully created (e.g., the username is missing or
  # invalid), it returns a JSON object with an "errors" key, containing an array
  # of error messages. The status is :unprocessable_entity (422).
  def create
    user = User.new(user_params)

    if user.save
      render json: user, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/users
  # This method returns a JSON representation of all users.
  def index
    users = User.all
    render json: users
  end

  # GET /api/v1/users/:id
  # This method returns a JSON representation of the user with the given ID.
  def show
    user = User.find(params[:id])
    render json: user if user
  end

  # GET /api/v1/users/find_by_username
  # This method returns a JSON representation of the user with the given username.
  def find_by_username
    user = User.find_by(username: params[:username])
    render json: user
  end

  # GET /api/v1/users/:user_id/reservations
  # List all reservations including the mentor information for a given user
  def user_reservations
    user = User.find(params[:id])
    reservations = user.reservations
    render json: reservations.as_json(methods: :formatted_times)
  end

  private

  # This private method is used to whitelist the parameters that can be used to
  # create a user. It requires the parameters to have a "user" key, under which
  # it permits a "username" key.
  #
  # This is a security feature to prevent users from updating sensitive model
  # attributes that they should not be able to update.
  def user_params
    params.require(:user).permit(:username)
  end
end
