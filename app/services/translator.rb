require 'super_memo'

class Translator
  attr_reader :card, :distance, :user_translation

  def initialize(card)
    @card = card
  end

  def translate(translation_text)
    @user_translation = translation_text

    @distance = Levenshtein.distance(full_downcase(card.translated_text),
                                    full_downcase(user_translation))

    sm_hash = SuperMemo.algorithm(card, distance, 1)

    if translated?
      sm_hash.merge!({ review_date: Time.now + card.interval.to_i.days, attempt: 1 })
    else
      sm_hash.merge!({ attempt: [card.attempt + 1, 5].min })
    end

    card.update(sm_hash)
  end

  def translated?
    distance <= 1
  end

  def correct_translation?
    distance == 0
  end

  def misprint_translation?
    distance == 1
  end

  protected

  def full_downcase(str)
    str.mb_chars.downcase.to_s.squeeze(' ').lstrip
  end
end
