class InvitationsController < ApplicationController
  before_action :set_invitation, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  def index
    @invitations = Invitation.all
    render json: @invitations
  end

  def show
    render json: @invitation
  end

  def new
    @invitation = Invitation.new
  end

  def edit
  end

  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.sender = @current_user

    if @invitation.save
      InvitationMailer.with(invitation: @invitation).invite_email.deliver_later
      render json: { message: "Convite criado com sucesso!" }, status: :created
    else
      render json: { errors: @invitation.errors }, location: @invitation, status: :unprocessable_entity
    end
  end

  def update
  end

  def destroy
    @invitation.destroy!
  end

  def accept_invitation
    @invitation = Invitation.find_by!(token: params[:token])

    if @invitation.expired?
      return redirect_to root_path, alert: "Este convite expirou."
    end

    unless @current_user.email == @invitation.email
      return redirect_to root_path, alert: "Este convite não pertence à sua conta."
    end

    project = @invitation.project

    ActiveRecord::Base.transaction do
      project.project_memberships.create!(
        user: @current_user,
        role: "member"
      )

      @invitation.destroy!
    end

      redirect_to project_path(project), notice: "Bem-vindo ao projeto #{project.name}!"
  rescue ActiveRecord::RecordInvalid => e
    redirect_to root_path, alert: "Erro ao aceitar convite: #{e.message}"
  end

  private

  def set_invitation
    @invitation = Invitation.find(params[:id])
  end

  def invitation_params
    params.require(:invitation).permit(:email, :project_id)
  end
end
