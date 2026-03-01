class UsersController < ApplicationController
  # skip_before_action :verify_authenticity_token, only: %i[ create ]
  before_action :set_user, only: %i[ show edit update destroy ]
  skip_before_action :authorize_request, only: %i[ new create ]

  def index
    @users = User.all
    render json: @users, except: [ :password_digest ]
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @user, except: [ :password_digest ] }
    end
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      respond_to do |format|
        format.html { redirect_to login_path, notice: "Conta criada com sucesso! Faça login." }
        format.json { render json: @user, status: :created, except: [ :password_digest ] }
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { errors: @user.errors }, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @user.update(user_params)
      respond_to do |format|
        format.html { redirect_to user_path(@user), notice: "Perfil atualizado com sucesso." }
        format.json { render json: @user, status: :ok, except: [ :password_digest ] }
      end
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
    unless @user == @current_user
      redirect_to root_path, alert: "Você não tem permissão para acessar este perfil."
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
