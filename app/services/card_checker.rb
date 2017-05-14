require 'super_memo'

class CardChecker
  include Interactor

  def call
    set_distance
    update_card
    set_result_messages
    context.fail! unless translated?
  end

  private

  def translated?
    context.distance <= 1
  end

  def missprint_tranclation?
    context.distance == 1
  end

  def set_distance
    context.distance = Levenshtein.distance(full_downcase(context.card.translated_text),
                                            full_downcase(context.user_translation))
  end

  def update_card
    sm_hash = SuperMemo.algorithm(context.card, context.distance, 1)

    if translated?
      sm_hash[:review_date] = Time.now + context.card.interval.to_i.days
      sm_hash[:attempt] = 1
    else
      sm_hash[:attempt] = [context.card.attempt + 1, 5].min
    end

    context.card.update(sm_hash)
  end

  def set_result_messages
    if translated?
      if missprint_tranclation?
        context.alert = I18n.t('translation_from_misprint_alert',
                               user_translation: context.user_translation,
                               original_text: context.card.original_text,
                               translated_text: context.card.translated_text)
      else
        context.notice = I18n.t(:correct_translation_notice)
      end
    else
      context.alert = I18n.t(:incorrect_translation_alert)
    end
  end

  def full_downcase(str)
    str.mb_chars.downcase.to_s.squeeze(' ').lstrip
  end
end
