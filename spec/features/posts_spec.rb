# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'
require 'session_helper'

RSpec.describe SessionController, type: :feature do
  include ActionView::Helpers
  include SessionHelper

  let!(:user_test) { User.new(username: 'user_test', password: '123_test_password').save }

  scenario 'trying to open post without login' do
    Post.create title: 'Post2', text: 'Text2', user_id: 'not_user_test'
    visit root_path
    expect(page).to have_content(t('session.login.login'))
    click_on t('posts.index.open')
    expect(page).to have_content(t('session.login.submit'))
  end

  scenario 'login and create post' do
    visit root_path
    expect(page).to have_content(t('posts.index.login'))
    click_on t('posts.index.login')
    fill_in 'login', with: 'user_test'
    fill_in 'password', with: '123_test_password'
    click_on t('session.login.submit')
    expect(page).to have_content(t('posts.index.logout'))
    click_on t('posts.index.create')
    fill_in 'post[title]', with: 'Title'
    fill_in 'post[text]', with: 'Text'
    click_on t('posts.new.create_post')
    expect(page).to have_content('Title')
    expect(page).to have_content('Text')
  end

  scenario 'login and edit post' do
    Post.create title: 'Post2', text: 'Text2', user_id: 'user_test'
    visit root_path
    expect(page).to have_content(t('posts.index.login'))
    click_on t('posts.index.login')
    fill_in 'login', with: 'user_test'
    fill_in 'password', with: '123_test_password'
    click_on t('session.login.submit')
    expect(page).to have_content(t('posts.index.logout'))

    click_on 'Open'
    click_on 'Edit'
    fill_in 'post[title]', with: 'Title_new'
    fill_in 'post[text]', with: 'Text_new'
    click_on 'Save Result'
    expect(page).to have_content('Title_new')
    expect(page).to have_content('Text_new')
  end

  scenario 'trying to edit not yours post' do
    Post.create title: 'Post2', text: 'Text2', user_id: 'not_user_test'
    visit root_path
    expect(page).to have_content(t('posts.index.login'))
    click_on t('posts.index.login')
    fill_in 'login', with: 'user_test'
    fill_in 'password', with: '123_test_password'
    click_on t('session.login.submit')

    click_on t('posts.index.open')

    expect(page).to have_no_content(t('posts.show.edit'))
  end 

  scenario 'deleting post' do
    Post.create title: 'Post2', text: 'Text2', user_id: 'user_test'
    visit root_path
    expect(page).to have_content(t('posts.index.login'))
    click_on t('posts.index.login')
    fill_in 'login', with: 'user_test'
    fill_in 'password', with: '123_test_password'
    click_on t('session.login.submit')

    click_on t('posts.index.open')
    click_on t('posts.show.edit')
    click_on t('posts.edit.delete_post')

    expect(page).to have_no_content('Text2')
  end #posts spec
end
