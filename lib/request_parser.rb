require 'apprentice_rota'
require 'error_command'
require 'foreman_command'
require 'menu'
require 'set_menu_command'
require 'get_menu_command'
require 'set_order_command'
require 'get_order_command'
require 'get_all_orders_command'
require 'reminder'
require 'place_order_guest'
require 'get_all_guests'

class RequestParser
  def initialize()
    @menu = Menu.new
    @apprentice_rota = ApprenticeRota.new({"id" => "Will", "id2" => "Fabien"})
    @commands = [SetMenuCommand.new(@menu)]
  end

  def parse(data)
    request = data[:user_message]

    for command in @commands
      if command.applies_to(request)
        command.prepare_message(request)
        return command
      end
    end

    if request == "menu?"
      GetMenuCommand.new(@menu)
    elsif request == "remind"
      Reminder.new(data)
    elsif request == "all orders?"
      GetAllOrdersCommand.new
    elsif request == "guests?"
      GetAllGuests.new
    elsif set_order_request?(request)
      lunch = request.gsub("order me: ", "")
      SetOrderCommand.new(lunch, data)
    elsif request.start_with?("order:") && request.split.size > 1
      GetOrderCommand.new(request)
    elsif request.start_with?("foreman")
      ForemanCommand.new(@apprentice_rota)
    elsif get_string_betwee_dash(request) && get_string_after_collon(request)
      PlaceOrderGuest.new(
        get_string_after_collon(request),
        get_string_betwee_dash(request),
        data[:user_id]
      )
    else
      ErrorCommand.new
    end
  end

  private

  def menu_request?(request)
    request.split.size == 3 &&
    request.include?("new menu") &&
    contain_url?(request)
  end

  def contain_url?(request)
    request[/((http|https):\/\/)?(w{3}.)?[A-Za-z0-9-]+.(com|co.uk)/]
  end

  def set_order_request?(request)
    request.start_with?("order me: ") && request.split.size > 2
  end

  def get_string_betwee_dash(message)
    message[/(?<=\-)(.+?)(?=\-)/]
  end

  def get_string_after_collon(message)
    message[/(?<=\:\s)(.+?)$/]
  end
end
