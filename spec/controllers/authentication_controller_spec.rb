require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do
  let (:user) {
    User.create(name: 'Jose', email: 'jose@gmail.com', password: 'password123')
  }

  describe "POST /login" do
    context "when credentials are valid" do
      it "returns a token successfully and sets a session" do
        post :login, params: { email: user.email, password: 'password123' }

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(root_path)
        expect(session[:jwt_token]).to_not be_nil
      end
    end

    context "when credentials are invalid" do
      it "shows an error" do
        post :login, params: { email: 'wrong@gmail.com', password: 'wrongpassword123' }

        expect(flash.now[:alert]).to eq("Email ou senha incorretos.")
      end
    end
  end

  describe "DELETE /logout" do
    let(:valid_token) {
      JsonWebToken.encode(user_id: user.id)
    }

    context "when token is not on blacklist" do
      before do
        session[:jwt_token] = valid_token
      end

      it "add token into the blacklist and redirects to root" do
        expect {
          delete :logout
        }.to change(BlacklistedToken, :count).by(1)

        expect(session[:jwt_token]).to eq(nil)
        expect(response).to redirect_to(root_path)
      end
    end
    context "when token is already on blacklist" do
      before do
        session[:jwt_token] = valid_token
        BlacklistedToken.create!(token: valid_token, expire_at: 24.hours.from_now)
      end

      it "is blocked by authorize_request and redirects to login" do
        expect {
          delete :logout
        }.to_not change(BlacklistedToken, :count)

        expect(session[:jwt_token]).to eq(nil)
        expect(response).to redirect_to(login_path)
      end
    end

    context "when there is no token in session" do
      it "redirects to login" do
        delete :logout

        expect(response).to redirect_to(login_path)
      end
    end
  end
end
