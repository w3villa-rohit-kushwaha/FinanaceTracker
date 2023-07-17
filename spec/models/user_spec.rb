require 'rails_helper'

RSpec.describe User, type: :model do
  # Configure FactoryBot
  before(:all) do
    FactoryBot.reload
  end


  describe "#stock_already_tracked?" do
    let(:user) { FactoryBot.create(:user, password: "password123") }
    let(:stock) { FactoryBot.create(:stock) }

    context "when user has already tracked the stock" do
      before do
        user.stocks << stock # Add the stock to the user's stocks association
      end

      it "returns true" do
        expect(Stock).to receive(:check_db).with(stock.ticker_symbol).and_return(stock) # Stub the Stock.check_db method to return the stock
        expect(user.stock_already_tracked?(stock.ticker_symbol)).to be true
      end
    end

    context "when user has not tracked the stock" do
      it "returns false" do
        expect(Stock).to receive(:check_db).with('XYZ').and_return(nil) # Stub the Stock.check_db method to return nil
        expect(user.stock_already_tracked?('XYZ')).to be false
      end
    end
  end

  describe "#under_stock_limit?" do
    let(:user) { FactoryBot.create(:user) }

    context "when user has less than 10 stocks" do
      it "returns true" do
        expect(user.under_stock_limit?).to be true
      end
    end

    context "when user has 10 or more stocks" do
      before do
        FactoryBot.create_list(:stock, 10, users: [user])
      end

      it "returns false" do
        expect(user.under_stock_limit?).to be false
      end
    end
  end

  describe "#can_track_stock?" do
    let(:user) { FactoryBot.create(:user, password: "password123") }
    let(:stock) { FactoryBot.create(:stock) }

    context "when user is under the stock limit and has not tracked the stock" do
      it "returns true" do
        expect(user.can_track_stock?(stock.ticker_symbol)).to be true
      end
    end

    context "when user has reached the stock limit" do
      before do
        FactoryBot.create_list(:stock, 10, users: [user])
      end

      it "returns false" do
        expect(user.can_track_stock?(stock.ticker_symbol)).to be false
      end
    end

    context "when user has already tracked the stock" do
      before do
        user.stocks << stock
      end

      it "returns true" do
        expect(user.can_track_stock?(stock.ticker_symbol)).to be true
      end
    end

  end

  describe ".search" do
    let!(:user1) { FactoryBot.create(:user, first_name: "John", last_name: "Doe", email: "john.doe@example.com") }
    let!(:user2) { FactoryBot.create(:user, first_name: "Jane", last_name: "Smith", email: "jane.smith@example.com") }
    let!(:user3) { FactoryBot.create(:user, first_name: "Peter", last_name: "Parker", email: "peter.parker@example.com") }

    context "when searching by first name" do
      it "returns users matching the given first name" do
        results = User.search("John")
        expect(results).to contain_exactly(user1)
      end
    end

    context "when searching by last name" do
      it "returns users matching the given last name" do
        results = User.search("Smith")
        expect(results).to contain_exactly(user2)
      end
    end

    context "when searching by email" do
      it "returns users matching the given email" do
        results = User.search("peter.parker@example.com")
        expect(results).to contain_exactly(user3)
      end
    end

    context "when searching with a non-matching parameter" do
      it "returns an empty array" do
        results = User.search("Nonexistent")
        expect(results).to eq([])
      end
    end

  end

  describe "#except_current_user" do
    let(:user) { FactoryBot.create(:user) }
    let(:friend1) { FactoryBot.create(:user) }
    let(:friend2) { FactoryBot.create(:user) }
    let(:friends) { [friend1, friend2] }

    context "when excluding the current user from the list of friends" do
      it "returns the list of friends without the current user" do
        results = user.except_current_user(friends)
        expect(results).to contain_exactly(friend1, friend2)
      end
    end
  end

  describe "#not_friends_with" do
  let(:user) { FactoryBot.create(:user) }
  let(:friend) { FactoryBot.create(:user) }
  let(:non_friend) { FactoryBot.create(:user) }

  context "when the user is not friends with the given friend" do
    it "returns true" do
      expect(user.not_friends_with(friend.id)).to be true
    end
  end

  context "when the user is friends with the given friend" do
    before do
      user.friends << friend
    end

    it "returns false" do
      expect(user.not_friends_with(friend.id)).to be false
    end
  end

  context "when the given friend does not exist" do
    it "returns true" do
      expect(user.not_friends_with(non_friend.id)).to be true
    end
  end
end

end
