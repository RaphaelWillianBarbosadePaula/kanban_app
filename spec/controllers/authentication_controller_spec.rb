require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do
  let (:user) {
    User.create(name: 'Jose', email: 'jose@gmail.com', password: 'password123')
  }

  describe "POST /auth/login" do
    context "when credentials are valid" do
      it "returns a token successfully" do
        post :login, params: { email: user.email, password: 'password123' }
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('token')
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context "when credentials are invalid" do
      it "returns an unauthorized response" do
        post :login, params: { email: 'wrong@gmail.com', password: 'wrongpassword123' }
        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('errors')
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end
end
