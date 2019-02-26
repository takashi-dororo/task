class ApplicationController < ActionController::Base
  # これを定義することで全てのビューでcurrent_userが使用できるようになる
  helper_method :current_user
  before_action :login_required

  # 例外ハンドル
  # unless Rails.env.development?
  #   rescue_from Exception,                      with: :_render_500
  #   rescue_from ActiveRecord::RecordNotFound,   with: :_render_404
  #   rescue_from ActionController::RoutingError, with: :_render_404
  # end
  #
  # def routing_error
  #   raise ActionController::RoutingError, params[:path]
  # end

  private
    #全てのコントローラで使用できる
    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end

    def login_required
      redirect_to login_path unless current_user
    end

    # def _render_404(e = nil)
    #   logger.info "Rendering 404 with exception: #{e.message}" if e
    #
    #   if request.format.to_sym == :json
    #     render json: { error: '404 error' }, status: :not_found
    #   else
    #     render 'errors/404', status: :not_found
    #   end
    # end
    #
    # def _render_500(e = nil)
    #   logger.error "Rendering 500 with exception: #{e.message}" if e
    #   Airbrake.notify(e) if e #Airbrake/Eraebitを使う場合はこちら？　あとで調べるAPIか？
    #
    #   if request.format.to_sym == :json
    #     render json: { error: '500 error' }, status: :internal_server_error
    #   else
    #     render 'errors/500', status: :internal_server_error
    #   end
    # end
end
