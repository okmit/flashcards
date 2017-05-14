module CardSetter
  extend ActiveSupport::Concern

  private

  def set_random_card
    @card = RandomCard.call(user: current_user, card_id: params[:id]).card
  end
end