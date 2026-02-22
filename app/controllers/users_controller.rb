class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_user, only: %i[ show edit update destroy ]

  def index
    @users = User.all
    render json: @users, except: [ :password_digest ]
  end

  def show
    render json: @user, except: [ :password_digest ]
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created, location: @user, except: [ :password_digest ]
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user, status: :ok, except: [ :password_digest ]
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy!
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
