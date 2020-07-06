class TweetsController < ApplicationController

# CRUD

# CREATE
  get '/tweets/new' do
    # load the create tweet form
    # tweet should be created and saved to the database
    redirect_if_not_logged_in
    erb :'tweets/new'
  end

  post '/tweets' do
    # process the form submission to create a new tweet
    if params[:content] == ""
      puts "ERROR: Post creation failure, please DO NOT submit blank tweet!"
      redirect to '/tweets/new'
    else
      @tweet = Tweet.build(content: params[:content]) # .create method saves automatically
      @tweet.save if authorized_user(@tweet)
      redirect to '/tweets'
    end
  end

# READ
  get '/tweets' do
    # tweets index page
    # display all tweets for logged in user and other users
    # if a user is not logged in, redirect to '/login'
      redirect_if_not_logged_in
      @tweets = Tweet.all
      erb :'tweets/tweets'
  end
  
  get '/tweets/:id' do
    # displays the information for a single tweet
      redirect_if_not_logged_in
      find_tweet
      erb :'tweets/show_tweet'
  end

# UPDATE
  get '/tweets/:id/edit' do
    redirect_if_not_logged_in
    find_tweet
    # if authorized_user(@tweet)
      erb :'tweets/edit_tweet'
    # else
    #   puts "ERROR: NOT authorized to edit this tweet!"
    #   redirect '/tweets/#{@tweet.id}'
    # end
    # ----- might not needed --------
  end

  patch '/tweets/:id' do
    ## ASK AYANA: Do we need to check "logged_in" again?
    if params[:content] == ""
      puts "ERROR: Edit creation failure, please DO NOT submit blank tweet!"
      redirect "/tweets/#{@tweet.id}/edit"
    else
      find_tweet
      @tweet.update(content: params[:content])
      redirect "/tweets/#{@tweet.id}" # anytime when I interpolate, use double ""
    end
  end

  # DELETE
  delete '/tweets/:id' do
    redirect_if_not_logged_in
    find_tweet
    if authorized_user(@tweet)
      @tweet.destroy
      redirect '/tweets'
    else
      puts "ERROR: NOT authorized to edit this tweet!"
      redirect "/tweets/#{@tweet.id}" # if this doesn't work, redirect to '/tweets'
    end
  end
end
