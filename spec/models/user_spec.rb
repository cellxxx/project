# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'
require 'session_helper'

RSpec.describe User, type: :routing do
  include ActionView::Helpers
  include SessionHelper

  let!(:user_test) { User.new(username: 'user_test', password: '123_test_password').save }

  describe 'find_user' do
    it 'should find user' do
      expect(User.find_by(username: 'user_test').valid?).to be(true)
    end

    it 'should not create duplicate user' do
      expect(User.new(username: 'user_test', password: '123_test_password').save).to be(false)
    end
  end

  it 'should update user' do
    user = User.find_by(username: 'user_test')
    user.update({ 'username' => 'user_test_new' })
    expect(User.find_by(username: 'user_test_new').valid?).to be(true)
    expect(User.find_by(username: 'user_test').nil?).to be(true)
  end

  it 'should destroy user' do
    user = User.find_by(username: 'user_test')
    user.destroy
    expect(User.find_by(username: 'user_test').nil?).to be(true)
  end
end
