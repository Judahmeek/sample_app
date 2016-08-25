require 'rails_helper'

RSpec.describe MicropostsController, type: :controller do
  fixtures :microposts, :users
  
  def log_in_as(user, options = {})
  	password		= options[:password]		|| 'password'
  	remember_me = options[:remember_me]	|| '1'
  	if defined?(post_via_redirect)
  		post login_path, session: { email:      user.email,
  									              password:   password,
  									              remember_me: remember_me }
		else
			 session[:user_id] = user.id
    end
  end
  
  describe "Unauthenticated Create Requests" do
    it " should not fulfill unauthenticated create requests" do
      expect{ post :create, micropost: { content: "Lorem ipsum" } }.to_not change { Micropost.count }
    end
    
    it "should redirect unauthenticated create requests to the login page" do
      expect( post :create, micropost: { content: "Lorem ipsum" } ).to redirect_to(login_url)
    end
  end
  
  describe "Unauthenticated Create Requests" do
    
    it "should not fulfill unauthenticated delete requests" do
      expect{ delete :destroy, id: microposts(:orange) }.to_not change { Micropost.count }
    end
    
    it "should redirect unauthenticated delete requests to the login page" do
      expect( delete :destroy, id: microposts(:orange) ).to redirect_to(login_url)
    end
  end
  
  describe "Unauthorized Delete Requests" do
    
    it "should not fulfill unauthorized delete requests" do
      log_in_as(users(:michael))
      expect{ delete :destroy, id: microposts(:ants) }.to_not change { Micropost.count }
    end
    
    it "should redirect unauthorized delete requests to the home page" do
      log_in_as(users(:michael))
      expect( delete :destroy, id: microposts(:ants) ).to redirect_to(root_url)
    end
  end
end