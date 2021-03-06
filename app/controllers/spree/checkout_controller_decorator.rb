Spree::CheckoutController.class_eval do

  # TODO Apply gift code in a before filter if possible to avoid overriding the update method for easier upgrades?
  def update
    if @order.update_attributes(object_params)
      fire_event('spree.checkout.update')
      render :edit and return unless apply_promo_code

      if @order.next
        state_callback(:after)
      else
        flash[:error] = t(:payment_processing_failed)
        redirect_to checkout_state_path(@order.state)
        return
      end

      if @order.state == 'complete' || @order.completed?
        flash.notice = t(:order_processed_successfully)
        flash[:commerce_tracking] = 'nothing special'
        redirect_to completion_route
      else
        redirect_to checkout_state_path(@order.state)
      end
    else
      render :edit
    end
  end

end
