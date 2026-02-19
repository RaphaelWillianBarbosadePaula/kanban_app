require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let (:valid_attributes) {
    attributes_for(:user)
  }

  let (:invalid_attributes) {
    { name: nil, email: nil, password: nil, password_confirmation: nil }
  }

  describe "GET #index" do
    it "returns a success response" do
      User.create! valid_attributes
      get :index, params: {}
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      user = User.create! valid_attributes
      get :show, params: { id: user.to_param }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "valid attributes" do
      it "creates new User" do
        expect {
          post :create, params: { user: valid_attributes }
      }.to change(User, :count).by(1)
      end

      it "renders a response with new user in JSON" do
          post :create, params: { user: valid_attributes }
          expect(response).to have_http_status(:created)
          expect(response.location).to eq(user_url(User.last))
          expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context "invalid attributes" do
      it "renders a response with errors for new user in JSON" do
        post :create, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_content)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe "PUT #update" do
    context "valid attributes" do
      let (:new_attributes) {
        { name: "newname" }
      }

      it "updates the requested user" do
        user = User.create! valid_attributes
        put :update, params: { id: user.to_param, user: new_attributes }
        expect(user.reload.name).to eq(new_attributes[:name])
      end

      it "renders a response with user in JSON" do
        user = User.create! valid_attributes
        put :update, params: { id: user.to_param, user: new_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context "invalid attributes" do
      it "renders a response with errors for user in JSON" do
        user = User.create! valid_attributes
        put :update, params: { id: user.to_param, user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_content)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the requested user" do
      user = User.create! valid_attributes
      expect {
        delete :destroy, params: { id: user.to_param }
      }.to change(User, :count).by(-1)
    end
  end
end
