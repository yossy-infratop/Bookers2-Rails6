class ContactMailer < ApplicationMailer
  def send_mail(title, content, group_users, owner) #メソッドに対して引数を設定
    @title = title
    @content = content
    mail from: owner.email, bcc: group_users.pluck(:email), subject: title
  end
end
