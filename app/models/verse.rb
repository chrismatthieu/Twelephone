class Verse < ActiveRecord::Base
  belongs_to :bible
  has_many :comments
  
  # named_scope :book, lambda { |book_id| { :conditions => ['book_id = ?', book_id] } }
  # named_scope :chapter, lambda { |chapter| { :conditions => ['chapter = ?', chapter] } }
  # named_scope :number, lambda { |number| { :conditions => ['number >= ?', number] } }
end
