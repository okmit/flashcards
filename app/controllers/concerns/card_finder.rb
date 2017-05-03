module CardFinder
  extend ActiveSupport::Concern

  included do
    helper_method :card
  end

  private

  def card
    @card ||= if params[:id]
                current_user.cards.find(params[:id])
              elsif current_user.current_block
                current_user.current_block.cards.pending.first || current_user.current_block.cards.repeating.first
              else
                current_user.cards.pending.first || current_user.cards.repeating.first
              end
  end
end