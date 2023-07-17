require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe "#my_portfolio" do
    it "assigns the tracked stocks of the current user to @tracked_stocks" do
      user = FactoryBot.create(:user)
      stocks = FactoryBot.create_list(:stock, 3)
      user.stocks << stocks

      sign_in user
      get :my_portfolio

      expect(assigns(:tracked_stocks)).to eq(stocks)
    end
  end

  describe "#my_friends" do
    it "assigns the friends of the current user to @friends" do
      user = FactoryBot.create(:user)
      friends = FactoryBot.create_list(:user, 3)
      user.friends << friends

      sign_in user
      get :my_friends

      expect(assigns(:friends)).to eq(friends)
    end
  end

  describe "#show" do
    it "assigns the user with the given id to @user" do
      user = FactoryBot.create(:user)

      get :show, params: { id: user.id }

      expect(assigns(:user)).to eq(user)
    end

    it "assigns the tracked stocks of the user to @tracked_stocks" do
      user = FactoryBot.create(:user)
      stocks = FactoryBot.create_list(:stock, 3)
      user.stocks << stocks

      get :show, params: { id: user.id }

      expect(assigns(:tracked_stocks)).to eq(stocks)
    end
  end

  describe "#search" do
    it "assigns the search results to @friends" do
      user = FactoryBot.create(:user)
      friend = FactoryBot.create(:user, first_name: "John", last_name: "Doe")
      user.friends << friend

      sign_in user
      get :search, params: { friend: "John" }

      expect(assigns(:friends)).to eq([friend])
    end

    it "renders the '_friend_result' partial" do
      user = FactoryBot.create(:user)

      sign_in user
      get :search, params: { friend: "John" }

      expect(response).to render_template(partial: '_friend_result')
    end
  end
end
