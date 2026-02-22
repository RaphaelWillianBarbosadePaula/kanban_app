class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def authorize_request
    header = request.headers["Authorization"]
    token = header.split(" ").last if header

    begin
      @decoded = JsonWebToken.decode(token)
      if @decoded
        @current_user = User.find(@decoded[:user_id])
      else
        render json: { errors: "Invalid token or expired" }, status: :unauthorized
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: "User not found" }, status: :unauthorized
    end
  end

  allow_browser versions: :modern
end
