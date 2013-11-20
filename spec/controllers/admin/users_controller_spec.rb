require 'spec_helper'

describe Admin::UsersController do
  include AuthHelper

  describe 'GET index' do
    it 'redirects if not logged in' do
      get :index
      response.should redirect_to :root
    end

    it 'redirects if logged in as visitor' do
      login_as(:visitor)
      get :index
      response.should redirect_to :root
    end

    it 'redirects if logged in as applicant' do
      login_as(:applicant)
      get :index
      response.should redirect_to :root
    end

    it 'renders if logged in as member' do
      login_as(:member)
      get :index
      response.should be_success
    end

    it 'renders if logged in as key member' do
      login_as(:key_member)
      get :index
      response.should be_success
    end
  end

  describe 'GET show' do
    it 'redirects if not logged in' do
      get :show, :id => User.make!.id
      response.should redirect_to :root
    end

    it 'redirects if logged in as visitor' do
      login_as(:visitor)
      get :index
      response.should redirect_to :root
    end
  end

  describe 'GET edit' do
    it 'redirects to root if logged out' do
      get :edit, :id => 1
      response.should redirect_to root_path
    end

    it 'redirects to root if logged in as visitor' do
      user = login_as(:visitor)
      get :edit, :id => user.id
      response.should redirect_to root_path
    end

    it 'redirects to root if logged in as applicant' do
      user = login_as(:applicant)
      get :edit, :id => user.id
      response.should redirect_to root_path
    end

    it 'renders if logged in as member' do
      user = login_as(:member)
      get :edit, :id => user.id
      response.should render_template :edit
    end
  end

  describe 'POST update' do
    it 'redirects to root if logged out' do
      post :update, :id => User.make!.id
      response.should redirect_to root_path
    end

    it 'redirects to root if logged in as visitor' do
      user = login_as(:visitor)
      post :update, :id => user.id
      response.should redirect_to root_path
    end

    it 'redirects to root if logged in as applicant' do
      user = login_as(:applicant)
      post :update, :id => user.id
      response.should redirect_to root_path
    end

    it 'updates name and email if logged in' do
      user = login_as(:member, :name => 'Foo Bar', :email => 'someone@foo.bar')

      post :update, :id => user.id, :user => {
        :name  => 'Foo2 Bar2',
        :email => 'someone2@foo.bar' }

      response.should redirect_to edit_admin_user_path(user)

      user.name.should eq('Foo2 Bar2')
      user.email.should eq('someone2@foo.bar')
    end
  end
end