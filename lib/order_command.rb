class SetOrderCommand
  attr_reader :response

  def initialize(message, order_list, event_data)
    @user_message = message
    @order_list = order_list
    @user_id = event_data[:user_id]
    @user_name = event_data[:user_name]
  end

  def response?
    response
  end

  def run()
    lunch = @user_message.gsub("order me: ", "")
    order = Order.new(@user_name, lunch, @user_id)
    @order_list.add_order(order)
    @response = "Your order `#{order.lunch}` is updated"
  end
end

class GetOrderCommand
  attr_reader :response

  def initialize(message, order_list)
    @user_message = message
    @order_list = order_list
  end

  def response?
    response
  end

  def run()
    user_message = @user_message.gsub("order: ", "")
    user_id_meal_researched = user_message[/(?<=\<@)(\w+)(?=>)/]
    meal = @order_list.find_lunch(user_id_meal_researched)
    @response = "<@#{user_id_meal_researched}> ordered: `#{meal}`"
  end
end
