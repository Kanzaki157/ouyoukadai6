class RelationshipsController < ApplicationController
  before_action :authenticate_user! #ログインしていない人にはこのコントローラーには遷移して欲しくないので！
  def  create
    following = current_user.relationships.build(followed_id: params[:user_id], follower_id: current_user.id) #current_userに紐付いたrelationshipを作成する事が出来るそして(follower_id: params[:user_id])を格納
   
    following.save
    redirect_to request.referrer || root_path #こう書く事で以前のpathに戻る事が出来る、そして以前のpathが見つからない可能性がある為、root_pathに遷移させる
  end
  
  def destroy #フォローを解除する時の記述
    following = current_user.relationships.find_by(follower_id: params[:user_id], follower_id: current_user.id) #current_user.relationshipsに紐付いたrelationshipsを全部とってくる find_by(follower_id: params[:user_id])でフォローを解除しようとしている対象のidが入る
    following.destroy
    redirect_to request.referrer || root_path
  end
end
