class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :authenticate_user!, unless: :devise_controller?
  rescue_from NameError, with: :handle_devise_session_error

  protected

  def after_sign_in_path_for(_resource)
    root_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  private

  def handle_devise_session_error(exception)
    return raise exception unless exception.message.include?("serialize_from_session")

    sign_out_all_scopes
    redirect_to new_user_session_path, alert: "Votre session a expiré, veuillez vous reconnecter."
  end
end
