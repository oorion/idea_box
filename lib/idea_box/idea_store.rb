require 'yaml/store'

class IdeaStore
  def self.database
    return @database if @database

    @database = YAML::Store.new "db/ideabox"
    @database.transaction do
      @database['ideas'] ||= []
    end
    @database
  end

  def self.create(attributes)
    database.transaction do
      database['ideas'] << attributes
    end
  end

  def self.all
    ideas = []
    raw_ideas.each_with_index do |data, i|
      ideas << Idea.new(data.merge("id" => i))
    end
    ideas
  end

  def self.raw_ideas
    database.transaction do |db|
      db['ideas'] || []
    end
  end

  def self.find(id)
    raw_idea = find_raw_idea(id)
    Idea.new(raw_idea.merge("id" => id))
  end

  def self.find_raw_idea(id)
    database.transaction do
      database['ideas'].at(id)
    end
  end

  def self.find_by_tag(tag)
    database.transaction do
      matching_ideas = database['ideas'].select do |idea|
        idea['tags'].include?(tag)
      end
      create_ideas_with_ids(matching_ideas)
    end
  end

  def self.sort_by_tags
    all.sort_by do |idea|
      idea.tags.first
    end
  end

  def self.create_ideas_with_ids(ideas)
    ideas.map do |idea|
      id = find_index_by_idea(idea)
      Idea.new(idea.merge("id" => id))
    end
  end

  def self.find_index_by_idea(idea)
    database['ideas'].index(idea)
  end

  def self.update(id, data)
    database.transaction do
      database['ideas'][id] = data
    end
  end

  def self.delete(position)
    database.transaction do
      database['ideas'].delete_at(position)
    end
  end
end
