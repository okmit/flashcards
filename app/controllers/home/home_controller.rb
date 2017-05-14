class Home::HomeController < Home::BaseController
  include CardSetter
  before_action :set_random_card

  def index
    respond_to do |format|
      format.html
      format.js
    end
  end
end
