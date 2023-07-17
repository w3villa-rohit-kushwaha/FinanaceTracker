require 'rails_helper'

RSpec.describe 'users/show', type: :view do
  before(:each) do
    @user = assign(:user, FactoryBot.create(:user)) # Assuming you have a User factory set up
    @tracked_stocks = [] # Assuming you want to test both scenarios, empty and non-empty tracked_stocks
  end

  it 'displays a message indicating no tracked stocks' do
    allow(view).to receive(:current_user).and_return(FactoryBot.build_stubbed(:user)) # Assuming you have a User factory set up

    render

    expect(rendered).to have_css('p.lead', text: 'This user is not tracking any stocks')
  end

  context 'when the user is tracking stocks' do
    before(:each) do
      @tracked_stocks = [FactoryBot.create(:stock)] # Assuming you have a Stock factory set up
    end

    it 'displays the user details' do
      allow(view).to receive(:current_user).and_return(FactoryBot.build_stubbed(:user)) # Assuming you have a User factory set up

      render

      expect(rendered).to have_css('h2', text: 'User Details')
      expect(rendered).to have_content(@user.first_name)
      expect(rendered).to have_content(@user.email)
    end


    it 'displays the "Follow friend?" button' do
      allow(view).to receive(:current_user).and_return(User.new) # Assuming you have a logged-in user

      render

      expect(rendered).to have_link('Follow friend?', href: friendships_path(friend: @user))
    end

    it 'displays the "You are friends" message' do
      allow(view).to receive(:current_user).and_return(User.new) # Assuming you have a logged-in user
      allow(view).to receive_message_chain(:current_user, :not_friends_with).and_return(false)

      render

      expect(rendered).to have_css('span.badge.badge-secondary', text: 'You are friends')
    end
    it 'renders the partial for tracking stocks' do
      user = FactoryBot.build_stubbed(:user) # Assuming you have a User factory set up
      allow(view).to receive(:current_user).and_return(user)
      @tracked_stocks = [FactoryBot.create(:stock)] # Assuming you have a Stock factory set up

      render

      expect(rendered).to render_template(partial: 'stocks/_list') # Updated partial name
    end


  end
end
