require 'idea_box'

class IdeaBoxApp < Sinatra::Base
  set :method_override, true
  set :root, 'lib/app'

  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    erb :index, locals: {ideas: IdeaStore.all.sort, groups: IdeaStore.groups}
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
    ideas = IdeaStore.find_by_tag(tag)
    erb :index, locals: {ideas: ideas}
  end

  get '/sort_by_tags' do
    erb :index, locals: {ideas: IdeaStore.sort_by_tags}
  end

  not_found do
    erb :error
  end
end
