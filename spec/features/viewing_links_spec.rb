feature 'view links' do 
  scenario 'I can see links on the page' do
    Link.new(url: 'http://www.makersacademy.com', ENV['DATABASE_URL'], title: 'Makers Academy').save
    visit '/links'
    expect(page.status_code).to eq 200
    within 'ul#links' do
      expect(page).to have_content('Makers Academy')
    end
  end
end
