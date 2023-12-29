# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'
require 'session_helper'

RSpec.describe SessionController, type: :feature do
  include ActionView::Helpers
  include SessionHelper

  let!(:user_test) { User.new(username: 'user_test', password: '123_test_password').save }

  scenario 'did not login yet' do
    visit root_path
    expect(page).to have_content(t('session.login.login'))
  end

  scenario 'trying to login' do
    visit root_path
    expect(page).to have_content(t('posts.index.login'))
    click_on t('posts.index.login')
    fill_in 'login', with: 'user_test'
    fill_in 'password', with: '123_test_password'
    click_on t('session.login.submit')
    expect(page).to have_content(t('posts.index.logout'))
  end

  scenario 'trying to login with incorrect credentials' do
    visit root_path
    expect(page).to have_content(t('session.login.login'))
    click_on t('session.login.login')
    fill_in 'login', with: 'user_test'
    fill_in 'password', with: '123_tasdfest_password'
    click_on t('session.login.submit')
    expect(page).to have_content(t('session.login.submit'))
  end #login spec
end
