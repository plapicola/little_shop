class CartController < ApplicationController
  before_action :require_shopper

  def show
    flash.notice = "Your cart is empty." unless @cart.contents
  end

  private

  def require_shopper
    render file: 'public/404' unless current_shopper?
  end

  def current_shopper?
    !(current_user && (current_user.admin? || current_user.merchant?))
  end
end
