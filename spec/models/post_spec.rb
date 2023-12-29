# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'
require 'session_helper'

RSpec.describe Post, type: :routing do
  include ActionView::Helpers
  include SessionHelper

  let!(:post1) { Post.create title: 'Post1', text: 'Text1', user_id: 'user_test' }
  let!(:post2) { Post.create title: 'Post2', text: 'Text2', user_id: 'not_user_test' }

  describe 'find posts' do
    it 'should find existing post by id' do
      expect(Post.find_by(id: 1).valid?).to be(true)
    end

    it 'should not find doesnt existing post' do
      expect(Post.find_by(id: 10).nil?).to be(true)
    end
  end

  describe 'get valid results' do
    it 'should get text' do
      text = 'Text1'
      expect(Post.find_by(id: 1).text).to eql(text)
    end

    it 'should get title' do
      title = 'Post1'
      expect(Post.find_by(id: 1).title).to eql(title)
    end
  end

  it 'should edit post' do
    post = Post.find_by(id: 1)
    post.update({ 'title' => 'New Title' })
    expect(Post.find_by(id: 1).title).to eql('New Title')
    expect(Post.find_by(id: 1).text).to eql('Text1')
  end

  it 'should destroy post' do
    post = Post.find_by(id: 2)
    post.destroy
    expect(Post.find_by(id: 2).nil?).to be(true)
  end
end
