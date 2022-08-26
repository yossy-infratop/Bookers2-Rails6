Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
  root to: 'homes#top'
  get 'home/about' => 'homes#about', as: 'about'
  resources :users, only:[:index, :show, :edit, :update] do
    resource :relationships, only: [:create, :destroy]
  	get 'followings' => 'relationships#followings', as: 'followings'
  	get 'followers' => 'relationships#followers', as: 'followers'
  end
  get 'users/:id/search' => 'users#search', as: 'user_search'
  get 'books/sort' => 'books#sort'
  get 'books/new' => redirect("books")
  post 'books/new' => 'books#new', as: 'new_books'
  resources :books, only:[:index, :show, :edit, :create, :update, :destroy] do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  resources :groups
  get ':id/join' => 'groups#join', as: 'group_join'
  get ':id/new_mail' => 'groups#new_mail', as: 'group_new_mail'
  get ':id/send_mail' => 'groups#send_mail', as: 'group_send_mail'
  resources :messages, only: [:create]
  resources :rooms, only: [:create, :show]
  get 'search' => 'searches#search'
  get 'search_tag' => 'searches#search_tag'
end
