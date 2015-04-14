require_relative 'idea_box'

class IdeaBoxApp < Sinatra::Base
  set :method_override, true
  set :root, 'lib/app'

  register Sinatra::Partial
  set :partial_template_engine, :erb

  configure :development do
    register Sinatra::Reloader
  end

  helpers do
    def escape_html(text)
      Rack::Utils.escape_html(text)
    end
  end

  get '/' do
    @ideas = IdeaStore.all.sort
    @groups = GroupStore.groups
    erb :index
  end

  post '/' do
    params[:idea]['tags'] = params[:idea]['tags'].split(", ")
    idea = IdeaStore.create(params[:idea])
    redirect '/'
  end

  get '/:id/edit' do |id|
    idea = IdeaStore.find(id.to_i)
    erb :edit, locals: {idea: idea}
  end

  put '/:id' do |id|
    IdeaStore.update(id.to_i, params[:idea])
    redirect '/'
  end

  delete '/:id' do |id|
    IdeaStore.delete(id.to_i)
    redirect '/'
  end

  post '/:id/like' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.like!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect '/'
  end

  get '/tag/:tag' do |tag|
    @ideas = IdeaStore.find_by_tag(tag)
    @groups = GroupStore.groups
    erb :index
  end

  get '/sort_by_tags' do
    @ideas = IdeaStore.sort_by_tags
    @groups = GroupStore.groups
    erb :index
  end

  post '/group/new' do
    GroupStore.create(params['group'])
    redirect '/'
  end

  get '/group/:name' do |name|
    @ideas = IdeaStore.find_by_group(name)
    @groups = GroupStore.groups
    erb :group, locals: {group_name: name}
  end

  delete '/group/:name' do |name|
    GroupStore.delete(name)
    @ideas = IdeaStore.find_by_group(name)
    @groups = GroupStore.groups
    erb :group, local: {group: name}
  end

  not_found do
    erb :error
  end
end
