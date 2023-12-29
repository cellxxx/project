# frozen_string_literal: true

require 'test_helper'

class SessionControllerTest < ActionDispatch::IntegrationTest
  include SessionHelper

  test 'unauthorized user can access to root page' do
    get root_url
    assert_response :success
  end

  test 'user with incorrect credentials will be redirected to login page' do
    get session_create_url, params: { login: 'user_test', password: '123' }
    assert_redirected_to controller: :session, action: :login
  end

  test 'user see the root' do
    password = '1123'

    user = User.create(username: 'user_test', password: password, password_confirmation: password)

    get session_create_url, params: { login: user.username, password: password }

    assert_redirected_to controller: :post, action: :index
  end

  test 'user can logout' do
    password = '123'

    user = User.create(username: 'user_test', password: password, password_confirmation: password)

    get session_create_url, params: { login: user.username, password: password }

    get session_logout_url

    assert_redirected_to controller: :session, action: :login
  end
end
