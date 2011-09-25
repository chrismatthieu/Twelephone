class Bible < ActiveRecord::Base
  has_many :verses, :order => "book_id, chapter, number"
end
