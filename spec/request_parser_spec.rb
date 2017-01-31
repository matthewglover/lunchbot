require 'request_parser'
require 'spec_helper'
require 'fake_channel_info_provider'

RSpec.describe RequestParser do
  let(:user_request) { RequestParser.new }

  it "return menu when the request is a menu" do
    request = {user_message: "new menu www.menu.com"}
    expect(user_request.parse(request)).to be_a(SetMenuCommand)
  end

  it "return error when the menu request has too munch arguments" do
    request = {user_message: "new menu www.menu.com bla"}
    expect(user_request.parse(request)).to be_a(ErrorCommand)
  end

  it "return error when the menu request hasn't enough arguments " do
    request = {user_message: "new www.menu.com"}
    expect(user_request.parse(request)).to be_a(ErrorCommand)
  end

  it "return error when the request keywork aren't correct" do
    request = {user_message: "lol menu www.menu.com"}
    expect(user_request.parse(request)).to be_a(ErrorCommand)
  end

  it "return error when the request doesn't provide an url" do
    request = {user_message: "new menu no-an-url"}
    expect(user_request.parse(request)).to be_a(ErrorCommand)
  end

  it "return get_menu when the person request for a menu" do
    request = {user_message: "menu?"}
    expect(user_request.parse(request)).to be_a(GetMenuCommand)
  end

  it "return error when get_menu request has more than one argument" do
    request = {user_message: "menu? ?"}
    expect(user_request.parse(request)).to be_a(ErrorCommand)
  end

  it "return set_order when it's a correct order request" do
    request = {user_message: "order me: name_of_the_menu"}
    expect(user_request.parse(request)).to be_a(SetOrderCommand)
  end

  it "return error when there is no space between colon and order" do
    request = {user_message: "order me:my meal"}
    expect(user_request.parse(request)).to be_a(ErrorCommand)
  end

  it "return error when the user order nothing" do
    request = {user_message: "order me:"}
    expect(user_request.parse(request)).to be_a(ErrorCommand)
  end

  it "return get_order when it's a correct request" do
    request = {user_message: "order: Fabien Townsend"}
    expect(user_request.parse(request)).to be_a(GetOrderCommand)
  end

  it "return error when it's a incorrect request" do
    request = {user_message: "order"}
    expect(user_request.parse(request)).to be_a(ErrorCommand)
  end

  it "return foreman when it's a correct request" do
    request = {user_message: "foreman"}
    expect(user_request.parse(request)).to be_a(ForemanCommand)
  end

  it "return all orders command  when it's a correct request" do
    request = {user_message: "all orders?"}
    expect(user_request.parse(request)).to be_a(GetAllOrdersCommand)
  end

  it "return PlaceOrderGuest when it's a correct request" do
    request = {user_message: "order -james smith-: burger"}
    expect(user_request.parse(request)).to be_a(PlaceOrderGuest)
  end

  it "return GetAllGuests" do
    request = {user_message: "guests?"}
    expect(user_request.parse(request)).to be_a(GetAllGuests)
  end

  it "return GetAllGuests" do
    request = {user_message: "remove guest: james"}
    expect(user_request.parse(request)).to be_a(RemoveGuestOrder)
  end

  it "return GetAllGuests" do
    request = {user_message: "add guest: james"}
    expect(user_request.parse(request)).to be_a(AddGuest)
  end

  it "returns NextForeman" do
    request = {user_message: "next foreman"}
    expect(user_request.parse(request)).to be_a(NextForeman)
  end

  it "returns AddApprentice" do
    request = {user_message: "add apprentice"}
    expect(user_request.parse(request)).to be_a(AddApprentice)
  end

  it "returns RemoveApprentice" do
    request = {user_message: "remove apprentice"}
    expect(user_request.parse(request)).to be_a(RemoveApprentice)
  end

  it "return remind command when it's a remind request" do
    request = {user_message: "remind", channel_info: FakeChannelInfoProvider.new, channel_id: "asdf", team_id: "team id"}
    expect(user_request.parse(request)).to be_a(Reminder)
  end
end