require 'nokogiri'
require 'pry'
require 'open-uri'
require 'colorize'
require_relative './comment.rb'

# PAGE_URL = "https://news.ycombinator.com/item?id=7663775"
# PAGE_URL = "./post.html"
HTML_FILE = open(ARGV[0])

class Post
  attr_accessor :new_comments
  @@doc = Nokogiri::HTML(HTML_FILE)

  def initialize
    @title   = (@@doc.css('head title').map { |title| title.inner_text }).join
    @url     = HTML_FILE
    @points  = (@@doc.search('.subtext > span:first-child').map { |span| span.inner_text}).first
    @item_id = (@@doc.search('.subtext > a:nth-child(3)'))[0]["href"]
    @comment_array = []
    @scraped_comments = (@@doc.search('body .comment').map { |comment_array| comment_array.inner_text })
    @scraped_comments.each { |comment| self.add_comment(comment) }

# binding.pry
  end

  def comments
    # returns all comments
    @comment_array.each do |comment_object| 
      puts (comment_object.text).colorize(:light_blue)
      puts '~~~~~'.colorize(:red)
    end
    puts
  end

  def add_comment(comment)
    # takes a comment as an argument and adds it to the comment array
    @comment_array.push(Comment.new(comment))
  end
end

# class Comment
#   def initialize
#   end
# end



p1 = Post.new
p1.comments

