Rails.application.routes.draw do
  get 'book_comments/create'
  get 'book_comments/destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  root :to =>"homes#top"
  get "home/about"=>"homes#about"
  get '/search', to: 'searches#search'
  resources :books, only: [:new,:index,:show,:edit,:create,:destroy,:update] do
    resource :favorites, only: [:create, :destroy]
    resources:book_comments,only:[:create,:destroy]
  end
  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
    get :followings, on: :member #あるユーザーがフォローしている人を全員を表示するためのルーティング on:memberとする事でルーティングにidを含ませることができる
    get :followers, on: :member #あるユーザーをフォローしてくれている人 フォロワーの一覧画面を表示させるためのルーティング
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
