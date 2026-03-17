class InvitationMailer < ApplicationMailer
  default from: "no-reply@kanbanapp.com"

  def invite_email
    @invitation = params[:invitation]
    @project = @invitation.project
    @sender = @invitation.sender

    @url = accept_invitations_url(token: @invitation.token)

    mail(
      to: @invitation.email,
      subject: "#{@sender.name} convidou você para o projeto #{@project.name}"
    )
  end
end
