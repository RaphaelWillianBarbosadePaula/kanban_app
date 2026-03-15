class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[ show edit update destroy ]
  before_action :authorize_member!, only: %i[ show edit update destroy ]

  def index
    @projects = @current_user.projects
    render json: @projects
  end

  def show
    render json: @project
  end
  
  def new
    @project = Project.new
  end

  def edit
  end

  def create
    @project = Project.new(project_params)
    @project.creator = @current_user

    if @project.save
      @project.project_memberships.create!(user: @current_user, role: 'owner')

      respond_to do |format|
        format.json { render json: @project, location: @project, status: :created }
      end
    else
      respond_to do |format|
        format.json { render json: { errors: @project.errors }, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @project.update(project_params)
      respond_to do |format|
        format.html
        format.json { render json: @project, status: :ok }
      end
    else
      respond_to do |format|
        format.html
        format.json { render json: { errors: @project.errors }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @project.destroy!
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description)
  end

  def authorize_member!
    unless @project.users.include?(@current_user)
      redirect_to root_path, alert: "Você não tem permissão para acessar este projeto."
    end
  end
end