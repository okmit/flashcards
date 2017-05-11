require 'super_memo'

class CardChecker
  include Interactor

  def call
    context.distance = Levenshtein.distance(full_downcase(context.card.translated_text),
                                            full_downcase(context.user_translation))
    sm_hash = SuperMemo.algorithm(context.card, context.distance, 1)

    if context.distance <= 1
      sm_hash[:review_date] = Time.now + context.card.interval.to_i.days
      sm_hash[:attempt] = 1

      if context.distance == 1
        context.alert = I18n.t('translation_from_misprint_alert',
                               user_translation: context.user_translation,
                               original_text: context.card.original_text,
                               translated_text: context.card.translated_text)
      else
        context.notice = I18n.t(:correct_translation_notice)
      end
    else
      sm_hash[:attempt] = [context.card.attempt + 1, 5].min
      context.alert = I18n.t(:incorrect_translation_alert)
    end

    context.card.update(sm_hash)

    context.fail! unless context.distance <= 1
  end

  protected

  def full_downcase(str)
    str.mb_chars.downcase.to_s.squeeze(' ').lstrip
  end
end
