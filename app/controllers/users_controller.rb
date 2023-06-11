class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update, :edit]

  def show
    @book = Book.new
    @user = User.find(params[:id])
    @books = @user.books
  end

  def index
    @users = User.all
    @user = current_user
    @book = Book.new
    @users = User.where.not(id: current_user.id) #ログインしている人以外のユーザー全部を取っていきたいので
  end
  
  def followings #あるユーザがフォローしている人全員を取得するアクションを定義する
    user = User.find(params[:id])
    @users = user.followings #このユーザーに結びついている、つまり、このuserがフォローしている人全員をとってくる事が出来る
  end
  
  def followers #あるユーザをフォローしている人全員を取得するアクションを定義する
    user = User.find(params[:id])
    @users = user.followers #このユーザをフォローしている人全員をとってくる事が出来る
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    @user.user_id = current_user.id
    if @user.save
      flash[:notice] = "You have updated user successfully."
      redirect_to user_path(@user.id)
    else
      flash[:alret] = "error"
    @users = User.all
    @user = current_user
    @book = Book.new
    render :index
    end
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "You have created book successfully."
    redirect_to user_path(@user.id)
    else
    flash[:alret] = "error"
    render :edit
    end
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
