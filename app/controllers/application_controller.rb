class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session, if: -> { request.format.json? }
  # allow_browser versions: :modern
  helper_method :current_user
  before_action :authorize_request

  def current_user
    @current_user
  end

  private
  def authorize_request
    @current_token = session[:jwt_token]

    return if @current_token.blank?

    begin
      @decoded = JsonWebToken.decode(@current_token)
      @current_user = User.find(@decoded[:user_id])

      if BlacklistedToken.exists?(token: @current_token)
        session[:jwt_token] = nil
        redirect_to login_path, alert: "Sua sessão expirou."
        return
      end
    rescue ActiveRecord::RecordNotFound
      session[:jwt_token] = nil
      @current_user = nil
      redirect_to login_path, alert: "Usuário não encontrado."
    end
  end

  def authenticate_user!
    if @current_user.nil?
      respond_to do |format|
        format.html { redirect_to login_path, alert: "Você precisa fazer login." }
        format.json { render json: { error: 'Não autorizado' }, status: :unauthorized }
      end
    end
  end
end
