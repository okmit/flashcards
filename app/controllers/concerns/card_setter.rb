module CardSetter
  extend ActiveSupport::Concern

  private

  def set_card
    result = RandomCard.call(user: current_user, card_id: params[:id])
    @card = result.success? ? result.card : nil
  end
end