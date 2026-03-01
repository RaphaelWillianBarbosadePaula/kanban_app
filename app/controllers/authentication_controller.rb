class AuthenticationController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :login ]
  # before_action :authorize_request, only: %i[ logout ]

  def login
    user = User.find_by_email(params[:email])

    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      session[:jwt_token] = token

      respond_to do |format|
        format.html { redirect_to root_path, notice: "Bem-vindo de volta!" }
        format.json { render json: { token: token, user: user.as_json(except: :password_digest) }, status: :ok }
      end
    else
      respond_to do |format|
        format.html {
          flash.now[:alert] = "Email ou senha incorretos."
          render :new, status: :unprocessable_entity
        }
        format.json { render json: { errors: "Incorreto" }, status: :unauthorized }
      end
    end
  end

  def logout
    if @current_token
      exp_time = Time.at(@decoded[:exp])
      BlacklistedToken.create!(token: @current_token, expire_at: exp_time)
    end
    session[:jwt_token] = nil
    redirect_to root_path, notice: "Até logo!"
  end
end
