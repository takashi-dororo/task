class TaskMailer < ApplicationMailer
  default from: 'noreply@example.com'

  #　引数として登録したオブジェクトを受け取る
  def creation_email(task)
    # メール本文のテンプレートで使いたいのでインスタンス変数に
    @task = task
    mail(
      subject: 'タスク作成完了通知',
      to: 'user@example.com',
      from: 'noreply@example.com'
    )
  end
end
