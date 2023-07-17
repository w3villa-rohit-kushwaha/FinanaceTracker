require 'rails_helper'

RSpec.describe 'users/my_portfolio', type: :view do
  before(:each) do
    assign(:stock, nil)
    assign(:tracked_stocks, [])
  end

  it 'displays the search form' do
    render

    expect(rendered).to have_css('form')
    expect(rendered).to have_field('stock')
    expect(rendered).to have_button('Search')
  end

  context 'when stock is present' do
    before(:each) do
      assign(:stock, FactoryBot.create(:stock)) # Assuming you have a Stock factory set up
    end

    it 'renders the result partial' do
      allow(view).to receive(:current_user).and_return(FactoryBot.build_stubbed(:user)) # Assuming you have a User factory set up
      assign(:stock, FactoryBot.create(:stock)) # Assuming you have a Stock factory set up

      render

      expect(rendered).to render_template(partial: 'users/_result') # Updated partial name
    end


  end

  context 'when tracked stocks are present' do
    before(:each) do
      assign(:tracked_stocks, [FactoryBot.create(:stock)]) # Assuming you have a Stock factory set up
    end

    it 'renders the stocks list partial' do
      allow(view).to receive(:current_user).and_return(FactoryBot.build_stubbed(:user)) # Assuming you have a User factory set up
      assign(:stock, FactoryBot.create(:stock)) # Assuming you have a Stock factory set up
      render

      expect(rendered).to render_template(partial: 'stocks/_list') # Updated partial name
    end

  end
end
