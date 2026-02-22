class AuthenticationController < ApplicationController
  def login
    user = User.find_by_email(params[:email])

    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      exp_time = 24.hours.from_now
      render json: { token: token, exp: exp_time }, status: :ok
    else
      render json: { errors: "Email or password incorrect." }, status: :unauthorized
    end
  end
end
