class ApplicationController < ActionController::Base
  allow_browser versions: :modern # se usar o posman, desabilite
  before_action :authorize_request

  private
  def authorize_request
    @current_token = session[:jwt_token]

    if @current_token.blank?
      redirect_to login_path, alert: "Você precisa fazer login para acessar essa página."
      return
    end

    if BlacklistedToken.exists?(token: @current_token)
      session[:jwt_token] = nil
      redirect_to login_path, alert: "Sua sessão expirou."
      return
    end

    begin
      @decoded = JsonWebToken.decode(@current_token)

      if @decoded
        @current_user = User.find(@decoded[:user_id])
      else
        session[:jwt_token] = nil
        redirect_to login_path, alert: "Token inválido ou expirado."
      end
    rescue ActiveRecord::RecordNotFound
      session[:jwt_token] = nil
      redirect_to login_path, alert: "Usuário não encontrado."
    end
  end
end
