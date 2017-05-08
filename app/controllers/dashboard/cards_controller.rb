class Dashboard::CardsController < Dashboard::BaseController
  before_action :set_card, except: [:index]
  before_action :set_cards, only: [:index]

  def index
  end

  def new
  end

  def edit
  end

  def create
    if @card.save
      redirect_to cards_path
    else
      respond_with @card
    end
  end

  def update
    if @card.update(card_params)
      redirect_to cards_path
    else
      respond_with @card
    end
  end

  def destroy
    @card.destroy
    respond_with @card
  end

  private

  def set_cards
    @cards ||= current_user.cards.order(review_date: :desc)
  end

  def set_card
    @card ||= if params[:id]
                current_user.cards.find(params[:id])
              elsif params[:card]
                current_user.cards.build(card_params)
              else
                Card.new
              end
  end

  def card_params
    params.require(:card).permit(:original_text, :translated_text, :review_date,
                                 :image, :image_cache, :remove_image, :block_id)
  end
end
