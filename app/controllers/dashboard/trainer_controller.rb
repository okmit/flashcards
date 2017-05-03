class Dashboard::TrainerController < Dashboard::BaseController
  include CardFinder

  def index
    respond_to do |format|
      format.html
      format.js
    end
  end

  def review_card
    translator.translate(trainer_params[:user_translation])

    if translator.translated?
      if translator.correct_translation?
        flash[:notice] = t(:correct_translation_notice)
      else
        flash[:alert] = t 'translation_from_misprint_alert',
                          user_translation: trainer_params[:user_translation],
                          original_text: card.original_text,
                          translated_text: card.translated_text
      end
      redirect_to trainer_path
    else
      flash[:alert] = t(:incorrect_translation_alert)
      redirect_to trainer_path(id: card.id)
    end
  end

  private

  def translator
    @translator ||= Translator.new(card)
  end

  def trainer_params
    params.permit(:user_translation)
  end
end
