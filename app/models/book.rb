class Book < ActiveRecord::Base
  has_many :author_books, dependent: :destroy
  has_many :authors, through: :author_books
  accepts_nested_attributes_for :author_books, allow_destroy: true
end
