require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:user) { User.create!(name: 'Jose', email: "jose@gmail.com", password: 'password123') }

  let(:valid_attributes) {
    { name: 'Novo Projeto', description: 'Descrição obrigatória' }
  }

  let(:invalid_attributes) {
    { name: nil, description: nil }
  }

  before do
    session[:jwt_token] = JsonWebToken.encode(user_id: user.id)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #index" do
    it "returns a success response" do
      Project.create! valid_attributes.merge(creator: user)
      get :index, params: {}
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      project = Project.create! valid_attributes.merge(creator: user)
      project.project_memberships.create!(user: user, role: 'owner')

      get :show, params: { id: project.to_param }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new Project" do
        expect {
          post :create, params: { project: valid_attributes }, format: :json
        }.to change(Project, :count).by(1)
      end

      it "renders a response with new project in JSON" do
        post :create, params: { project: valid_attributes }, format: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context "with invalid attributes" do
      it "renders a response with errors in JSON" do
        post :create, params: { project: invalid_attributes }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT #update" do
    it "updates the requested project" do
      project = Project.create! valid_attributes.merge(creator: user)
      project.project_memberships.create!(user: user, role: 'owner')

      put :update, params: { id: project.to_param, project: { name: 'Novo Nome' } }, format: :json
      expect(project.reload.name).to eq('Novo Nome')
      expect(response).to be_successful
    end
  end

  describe "DELETE #destroy" do
    it "deletes the requested project" do
      project = Project.create! valid_attributes.merge(creator: user)
      project.project_memberships.create!(user: user, role: 'owner')

      expect {
        delete :destroy, params: { id: project.to_param }
      }.to change(Project, :count).by(-1)
    end
  end

  describe "GET #index_members" do
    let(:project) { Project.create!(name: 'Projeto Teste', description: 'Desc', creator: user) }

    before do
      project.project_memberships.create!(user: user, role: 'owner')
    end

    it "retorna com sucesso a lista de membros" do
      get :index_members, params: { id: project[:id] }
      
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.first["user"]["name"]).to eq('Jose')
    end
  end
end
