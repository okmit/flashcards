class RandomCard
  include Interactor

  def call
    context.card = if context.card_id
      context.user.cards.find(context.card_id)
    elsif context.user.current_block
      context.user.current_block.cards.pending.first || context.user.current_block.cards.repeating.first
    else
      context.user.cards.pending.first || context.user.cards.repeating.first
    end

    context.fail! unless context.card
  end
end