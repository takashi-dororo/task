class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @q = current_user.tasks.ransack(params[:q])
    @tasks = @q.result(distinct: true).page(params[:page]).per(15)
    # ransack導入前
    # @tasks = current_user.tasks.recent
    # @tasks = Task.where(user_id: current_user.id).order(created_at: :desc)　とほぼ同じ(キャッシュの有無)

    #csv出力用
    respond_to do |format|
      format.html
      format.csv { send_data @tasks.generate_csv, filename: "tasks-#{Time.zone.now.strftime('%Y%m%d%S')}.csv" }
    end
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.new(task_params.merge(user_id: current_user.id))
    # @task = current_user.tasks.build(task_params) でもok buildをnewにする場合もある
    # 登録内容確認画面の戻るボタンの設定
    if params[:back].present?
      render :new
      return
    end

    if @task.save
      logger.debug "task: #{@task.attributes.inspect}"
      TaskMailer.creation_email(@task).deliver_now
      SampleJob.perform_later
      redirect_to @task, notice: "タスク『#{@task.name}』を登録しました。"
    else
      render :new
    end
  end

  def edit
  end

  # @taskインスタンス変数に変更したが、set_taskで処置を統一する前は変数 taskでok
  def update
    @task.update!(task_params)
    redirect_to tasks_url, notice: "タスク『#{@task.name}』を更新しました"
  end

  def destroy
    @task.destroy
    # Ajax向けに変更
    head :no_content
    # redirect_to tasks_url, notice: "タスク『#{@task.name}』を削除しました"
  end

  def confirm_new
    @task = current_user.tasks.new(task_params)
    render :new unless @task.valid?
  end

  def import
    current_user.tasks.import(params[:file])
    redirect_to tasks_url, notice: "タスクを追加しました"
  end

  private
    #画像機能追加で :image属性を追加。画像添付機能なしならば消す
    def task_params
      params.require(:task).permit(:name, :description, :image)
    end

    def set_task
      @task = current_user.tasks.find(params[:id])
    end
end
