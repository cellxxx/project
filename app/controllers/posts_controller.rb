# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy add_comment]
  skip_before_action :require_login, only: %i[index]
  skip_around_action :switch_locale, only: %i[add_comment]

  # GET /posts or /posts.json
  def index
    @posts = Post.all.reverse
  end

  # GET /posts/1 or /posts/1.json
  def show; 
    if request.format.js?
      comment = Comment.create( { 'username'=>current_user.username, 'content'=>post_params[:comment] } )
      @post.comments = "#{comment.id} #{(@post.comments.nil?) ? '' : @post.comments}"
    end

    respond_to do |format|
      if @post.save
        format.html
        format.js
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
    
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # POST /posts or /posts.json
  def create
    params = post_params
    params['user_id'] = current_user[:username]

    @post = Post.new(params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /posts/1/edit
  def edit
    check_auth_user
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    check_auth_user

    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    check_auth_user

    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def delete_image_attachment
    @image = ActiveStorage::Blob.find_signed(params[:id])
    @image.attachments.first.purge_later
    redirect_to posts_url
  end

  def add_comment
    comment = Comment.create( { 'username'=>current_user.username, 'content'=>params[:comments] } )
    @post.comments = "#{comment.id} #{(@post.comments.nil?) ? '' : @post.comments}" 

    respond_to do |format|
      if @post.save
        format.html
        format.js { render :js => "alert();" }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:title, :text, :avatar, :comment)
  end

  def check_auth_user
    redirect_to root_path if @post.user_id != current_user.username
  end
end
