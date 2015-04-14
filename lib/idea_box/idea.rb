class Idea
  include Comparable

  attr_reader :title, :description, :rank, :id, :tags, :group

  def initialize(attributes={})
    @title = attributes["title"]
    @description = attributes["description"]
    @rank = attributes["rank"] || 0
    @id = attributes["id"]
    @tags = attributes["tags"]
    @group = attributes["group"]
  end

  def save
    IdeaStore.create(to_h)
  end

  def to_h
    {
      "title" => title,
      "description" => description,
      "rank" => rank,
      # "id" => id,
      "tags" => tags,
      "group" => group
    }
  end

  def like!
    @rank += 1
  end

  def <=>(other)
    other.rank <=> rank
  end
end
