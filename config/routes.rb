Rails.application.routes.draw do
  scope '/v1' do
    ######################################################
    # Authenticated user
    get   '/' => 'user#get_current_user'

    scope '/devices' do
      scope '/push-token' do
        post    '/' => 'device#set_push_token'
        delete  '/' => 'device#remove_push_token'
      end
    end

    scope '/login' do
      post    '/' => 'user#login'
    end

    scope '/logout' do
      post    '/' => 'user#logout'
    end

    scope '/sign-up' do
      post    '/' => 'user#create_login'
    end

    scope '/qr' do
      get    '/' => 'user#get_qr_code'
    end
    ######################################################

    ######################################################
    # Managing Films
    scope '/films' do
      get '/' => 'film#index'
      scope '/:film_id' do
        post '/rate' => 'watch#create_watch'
      end
    end

    scope '/ratings' do
      get     '/' => 'watch#index_ratings'
    end

    scope '/watch-list' do
      get     '/' => 'watch#index_watch_list'
    end

    concern :watch do
      post    '/' => 'watch#create_watch'
      delete  '/' => 'watch#delete_watch'
    end
    scope '/watch-list' do
      concerns :watch
    end
    scope '/ratings'   do
      concerns :watch
    end
    ######################################################

    ######################################################
    # Searching
    scope '/search' do
      get '/' => 'search#search'
    end
    ######################################################

    ######################################################
    # Managing Other Users
    scope '/users/:username' do
      get     '/'  => 'user#get_user'
      post    '/'  => 'user#follow_unfollow_user'
      delete  '/'  => 'user#follow_unfollow_user'
      get '/ratings' => 'watch#index_ratings'
      get '/watch-list' => 'watch#index_watch_list'
      get '/followers' => 'user#index_followers'
      get '/following' => 'user#index_following'
    end

    scope '/feed' do
      get '/' => 'feed#index'
    end
    ######################################################
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
