class AddTestUser < ActiveRecord::Migration
  def change
    if User.all.size == 0
      User.create(:email => 'test@email.com', :password => 'test123456')
    end
  end
end
