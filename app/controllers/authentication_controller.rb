class AuthenticationController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authorize_request, only: %i[ logout ]

  def login
    user = User.find_by_email(params[:email])

    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      session[:jwt_token] = token

      redirect_to root_path, notice: "Login realizado com sucesso!"
    else
      flash.now[:alert] = "Email ou senha incorretos."

      # Because new is not created yet in project, returns to the login path again
      # render :new
      redirect_to login_path, alert: "Email ou senha incorretos."
    end
  end

  def logout
    exp_time = Time.at(@decoded[:exp])
    BlacklistedToken.create!(token: @current_token, expire_at: exp_time)

    session[:jwt_token] = nil

    redirect_to root_path, notice: "Logout realizado com sucesso."
  end
end
