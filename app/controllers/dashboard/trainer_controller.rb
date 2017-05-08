class Dashboard::TrainerController < Dashboard::BaseController
  include CardSetter
  before_action :set_card, only: [:index, :review_card]

  def index
    respond_to do |format|
      format.html
      format.js
    end
  end

  def review_card
    result = CardChecker.call(card: @card, user_translation: trainer_params[:user_translation])

    if result.success?
      redirect_to trainer_path, alert: result.alert, notice: result.notice
    else
      redirect_to trainer_path(id: @card.id), alert: result.alert
    end
  end

  private

  def trainer_params
    params.permit(:user_translation)
  end
end
