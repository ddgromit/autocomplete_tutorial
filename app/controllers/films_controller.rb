class FilmsController < ApplicationController
  # GET /films
  # GET /films.json
  def index
    @films = Film.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @films }
    end
  end

  # GET /films/1
  # GET /films/1.json
  def show
    @film = Film.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @film }
    end
  end

  # GET /films/new
  # GET /films/new.json
  def new
    @film = Film.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @film }
    end
  end

  # GET /films/1/edit
  def edit
    @film = Film.find(params[:id])
  end

  # POST /films
  # POST /films.json
  def create
    @film = Film.new(params[:film])

    respond_to do |format|
      if @film.save
        format.html { redirect_to @film, notice: 'Film was successfully created.' }
        format.json { render json: @film, status: :created, location: @film }
      else
        format.html { render action: "new" }
        format.json { render json: @film.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /films/1
  # PUT /films/1.json
  def update
    @film = Film.find(params[:id])

    respond_to do |format|
      if @film.update_attributes(params[:film])
        format.html { redirect_to @film, notice: 'Film was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @film.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /films/1
  # DELETE /films/1.json
  def destroy
    @film = Film.find(params[:id])
    @film.destroy

    respond_to do |format|
      format.html { redirect_to films_url }
      format.json { head :no_content }
    end
  end

  def autocomplete
    keys = YAML.load_file(Rails.root.join("config","netflix.yml"))[Rails.env]
    consumer = OAuth::Consumer.new(keys["consumer_key"], keys["consumer_secret"],
        :site => "http://api-public.netflix.com", 
        :request_token_url => "http://api-public.netflix.com/oauth/request_token", 
        :access_token_url => "http://api-public.netflix.com/oauth/access_token", 
        :authorize_url => "https://api-user.netflix.com/oauth/login")

    # Create the Request
    args = {
      :output => "json",
      :term => params[:term],
      :max_results => 5
    }
    url = "http://api-public.netflix.com/catalog/titles?#{args.to_query}"
    req = consumer.create_signed_request :get, url
    response = JSON.parse consumer.http.request(req).body

    # Construct autocomplete source
    titles = response["catalog_titles"]["catalog_title"]
    jsons = titles.map do |title|
      {
        :label => "#{title["title"]["regular"]} (#{title["release_year"]})", 
        :netflix_id => title["id"]
      }
    end
    render :json => jsons
  end
end
